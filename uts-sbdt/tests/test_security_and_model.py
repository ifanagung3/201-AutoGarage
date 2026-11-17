import importlib.util
import json
import sys
import time
from pathlib import Path
from types import SimpleNamespace

import jwt
import pandas as pd
import pytest
from cryptography.hazmat.primitives.asymmetric import rsa
from fastapi import HTTPException
from fastapi.testclient import TestClient

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'backend'))
from app import main

@pytest.fixture(scope='module')
def key():return rsa.generate_private_key(public_exponent=65537,key_size=2048)

@pytest.fixture
def claims():
    return {'iss':main.ISSUER,'aud':main.AUDIENCE,'sub':'test-owner',
            'exp':int(time.time())+300,'realm_access':{'roles':['autogarage_user']}}

@pytest.fixture
def signing_key(monkeypatch,key):
    monkeypatch.setattr(main.jwks,'get_signing_key_from_jwt',lambda token:SimpleNamespace(key=key.public_key()))
    return key

def test_rsa_signature_and_claims(signing_key,claims):
    token=jwt.encode(claims,signing_key,algorithm='RS256',headers={'kid':'test-key'})
    assert main.validate_token(token)['sub']=='test-owner'

@pytest.mark.parametrize('change',[
    {'aud':'wrong-client'},{'iss':'https://invalid.example.test'},
    {'exp':int(time.time())-60},{'nbf':int(time.time())+600},
])
def test_reject_invalid_claims(signing_key,claims,change):
    token=jwt.encode({**claims,**change},signing_key,algorithm='RS256')
    with pytest.raises(HTTPException) as exc:main.validate_token(token)
    assert exc.value.status_code==401

def test_reject_wrong_signature(signing_key,claims):
    other=rsa.generate_private_key(public_exponent=65537,key_size=2048)
    with pytest.raises(HTTPException) as exc:main.validate_token(jwt.encode(claims,other,algorithm='RS256'))
    assert exc.value.status_code==401

@pytest.mark.parametrize('field',['exp','iss','aud','sub'])
def test_required_claims(signing_key,claims,field):
    claims.pop(field)
    with pytest.raises(HTTPException) as exc:main.validate_token(jwt.encode(claims,signing_key,algorithm='RS256'))
    assert exc.value.status_code==401

def test_reject_missing_role(signing_key,claims):
    claims['realm_access']={'roles':[]}
    with pytest.raises(HTTPException) as exc:main.validate_token(jwt.encode(claims,signing_key,algorithm='RS256'))
    assert exc.value.status_code==403

def test_no_token_rejected_before_database():
    client=TestClient(main.app)
    assert client.get('/history').status_code==401

def test_pkce_rfc7636_vector():
    client=TestClient(main.app)
    response=client.post('/pkce/challenge',json={'verifier':'dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk'})
    assert response.json()['challenge']=='E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM'

def test_real_random_forest_training_and_missing_artifact(tmp_path):
    spec=importlib.util.spec_from_file_location('training',ROOT/'backend/training/train_model.py')
    training=importlib.util.module_from_spec(spec);spec.loader.exec_module(training)
    report=training.train(output_dir=tmp_path/'models')
    models=main.load_models(tmp_path/'models')
    frame=pd.read_csv(ROOT/'backend/training/dataset_bengkel.csv')[training.FEATURES].iloc[:1]
    assert models['cost'].predict(frame)[0]>0
    assert models['duration'].predict(frame)[0]>0
    assert report['rows']==10 and report['holdout_rows']==2
    assert report['model_version']==models['manifest']['model_version']
    with pytest.raises(OSError):main.load_models(tmp_path/'absent')

@pytest.mark.parametrize('change',[{'mileage':-1},{'component_count':0},{'user_id':'forged-owner'}])
def test_invalid_payload_rejected(change):
    payload={'car_brand':'Toyota','car_model':'Avanza','car_year':2018,
             'service_type':'Tune Up','mileage':75000,'component_count':5}
    with pytest.raises(ValueError):main.VehicleInput(**{**payload,**change})

def test_model_unavailable_fails_closed():
    main.app.dependency_overrides[main.current_user]=lambda:{'sub':'test-owner'}
    main.app.state.models=None
    try:
        response=TestClient(main.app).post('/predict',json={'car_brand':'Toyota','car_model':'Avanza',
            'car_year':2018,'service_type':'Tune Up','mileage':75000,'component_count':5})
        assert response.status_code==503
    finally:main.app.dependency_overrides.clear()
