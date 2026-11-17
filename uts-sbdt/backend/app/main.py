import json
import base64
import hashlib
import logging
import os
from contextlib import asynccontextmanager
from pathlib import Path
from typing import Annotated

import joblib
import jwt
import pandas as pd
import psycopg
from fastapi import Depends, FastAPI, HTTPException, Request, Response
from fastapi.responses import FileResponse
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from pydantic import BaseModel, ConfigDict, Field
from psycopg.conninfo import make_conninfo
from psycopg.rows import dict_row
from psycopg.types.json import Jsonb
from psycopg_pool import ConnectionPool, PoolTimeout

LOG = logging.getLogger(__name__)
ISSUER = os.getenv('OIDC_ISSUER','http://auth.lokal:8080/realms/autogarage')
AUDIENCE = os.getenv('OIDC_AUDIENCE','autogarage-api')
JWKS_URL = os.getenv('OIDC_JWKS_URL','http://keycloak:8080/realms/autogarage/protocol/openid-connect/certs')
jwks = jwt.PyJWKClient(JWKS_URL, cache_keys=True, lifespan=60)
bearer = HTTPBearer(auto_error=False)

def validate_token(token):
    try:
        key = jwks.get_signing_key_from_jwt(token).key
        claims = jwt.decode(token, key, algorithms=['RS256'], audience=AUDIENCE,
                            issuer=ISSUER, options={'require':['exp','iss','aud','sub']})
    except jwt.PyJWKClientConnectionError:
        raise HTTPException(503,'Layanan kunci SSO belum tersedia') from None
    except jwt.PyJWTError:
        raise HTTPException(401,'Access token tidak valid', headers={'WWW-Authenticate':'Bearer'}) from None
    if not isinstance(claims['sub'], str) or not claims['sub']:
        raise HTTPException(401,'Identitas token tidak valid')
    roles = claims.get('realm_access',{}).get('roles',[])
    if 'autogarage_user' not in roles:
        raise HTTPException(403,'Peran pengguna tidak memiliki akses')
    return claims

def current_user(credentials: Annotated[HTTPAuthorizationCredentials | None, Depends(bearer)]):
    if credentials is None or credentials.scheme.lower() != 'bearer':
        raise HTTPException(401,'Login diperlukan',headers={'WWW-Authenticate':'Bearer'})
    return validate_token(credentials.credentials)

def make_pool(host, user):
    info = make_conninfo(host=host,port=os.getenv('DB_PORT','5432'),
        dbname=os.getenv('DB_NAME','autogarage'),user=user,
        password=os.environ['APP_DB_PASSWORD'],connect_timeout=5)
    return ConnectionPool(info,min_size=1,max_size=5,timeout=5,open=False,
        kwargs={'row_factory':dict_row})

def load_models(directory):
    directory = Path(directory)
    return {'cost':joblib.load(directory/'model_cost.pkl'),
            'duration':joblib.load(directory/'model_duration.pkl'),
            'manifest':json.loads((directory/'manifest.json').read_text())}

@asynccontextmanager
async def lifespan(app):
    app.state.models = None
    try:
        app.state.models = load_models(os.getenv('MODEL_DIR','models'))
    except (OSError, ValueError):
        LOG.exception('Artefak model tidak tersedia; readiness dinonaktifkan')
    app.state.write_pool = make_pool(os.getenv('DB_WRITE_HOST','postgres-primary'),'app_writer')
    app.state.read_pool = make_pool(os.getenv('DB_READ_HOST','postgres-replica'),'app_reader')
    app.state.write_pool.open(wait=False)
    app.state.read_pool.open(wait=False)
    yield
    app.state.write_pool.close()
    app.state.read_pool.close()

app = FastAPI(title='201 Auto Garage - UTS SBDT',version='1.0.0',lifespan=lifespan)

class VehicleInput(BaseModel):
    model_config = ConfigDict(extra='forbid')
    car_brand: str = Field(min_length=1,max_length=80)
    car_model: str = Field(min_length=1,max_length=80)
    car_year: int = Field(ge=1980,le=2030)
    service_type: str = Field(min_length=1,max_length=80)
    mileage: int = Field(ge=0,le=1000000)
    component_count: int = Field(ge=1,le=50)

def identity(conn, replica):
    result=conn.execute('SELECT pg_is_in_recovery() AS in_recovery, '
                        'inet_server_addr()::text AS server, current_user AS db_user').fetchone()
    if result['in_recovery'] is not replica:
        raise HTTPException(503,'Peran basis data tidak sesuai rute')
    return result

@app.get('/health')
def health():
    return {'status':'online','service':'201 Auto Garage UTS API'}

@app.get('/ready')
def ready(request: Request):
    if request.app.state.models is None:
        raise HTTPException(503,'Model belum tersedia')
    try:
        for pool,replica in [(request.app.state.write_pool,False),(request.app.state.read_pool,True)]:
            with pool.connection() as conn:
                identity(conn,replica)
    except (psycopg.Error,PoolTimeout):
        raise HTTPException(503,'Basis data belum siap') from None
    return {'status':'ready','model_version':request.app.state.models['manifest']['model_version']}

@app.get('/config')
def config():
    return {'issuer':ISSUER,'client_id':'autogarage-web'}

class VerifierInput(BaseModel):
    verifier: str = Field(min_length=43,max_length=128,pattern=r'^[A-Za-z0-9_-]+$')

@app.post('/pkce/challenge')
def pkce_challenge(payload: VerifierInput):
    # HTTP custom hostnames in a local lab do not expose WebCrypto.subtle.
    # Stateless S256 helper: does not store or log the verifier. Use HTTPS outside the lab.
    digest=hashlib.sha256(payload.verifier.encode('ascii')).digest()
    return {'challenge':base64.urlsafe_b64encode(digest).rstrip(b'=').decode('ascii')}

@app.get('/demo')
def demo():
    return FileResponse(Path(__file__).with_name('demo.html'))

@app.get('/me')
def me(user: Annotated[dict,Depends(current_user)]):
    return {'sub':user['sub'],'name':user.get('name',user.get('preferred_username','Pengguna')),
            'username':user.get('preferred_username'), 'authentication':'Keycloak OIDC / JWKS'}

@app.post('/predict')
def predict(payload: VehicleInput,request: Request,response: Response,
            user: Annotated[dict,Depends(current_user)]):
    models=request.app.state.models
    if models is None:
        raise HTTPException(503,'Model belum tersedia')
    values=payload.model_dump()
    frame=pd.DataFrame([values])
    cost=max(0,round(float(models['cost'].predict(frame)[0])/5000)*5000)
    duration=max(0,round(float(models['duration'].predict(frame)[0]),1))
    version=models['manifest']['model_version']
    try:
        with request.app.state.write_pool.connection() as conn:
            db=identity(conn,False)
            row=conn.execute('INSERT INTO inference_history '
                '(user_id,input_payload,estimated_cost,estimated_duration,model_version) '
                'VALUES (%s,%s,%s,%s,%s) RETURNING id,created_at',
                (user['sub'],Jsonb(values),cost,duration,version)).fetchone()
        # pool context commits before a successful response is returned.
    except (psycopg.Error,PoolTimeout):
        LOG.exception('Penyimpanan hasil inferensi gagal')
        raise HTTPException(503,'Hasil belum tersimpan; silakan coba kembali') from None
    response.headers['X-Database-Role']='replica' if db['in_recovery'] else 'primary'
    return {**row,'estimated_cost':cost,'estimated_duration':duration,
            'model_version':version,'status':'success'}

@app.get('/history')
def history(request: Request,response: Response,user: Annotated[dict,Depends(current_user)]):
    try:
        with request.app.state.read_pool.connection() as conn:
            db=identity(conn,True)
            rows=conn.execute('SELECT id,input_payload,estimated_cost,estimated_duration,'
                'model_version,created_at FROM inference_history WHERE user_id=%s '
                'ORDER BY created_at DESC,id DESC LIMIT 50',(user['sub'],)).fetchall()
    except (psycopg.Error,PoolTimeout):
        raise HTTPException(503,'Riwayat belum tersedia') from None
    response.headers['X-Database-Role']='replica' if db['in_recovery'] else 'primary'
    return {'items':rows,'read_source':'replica'}
