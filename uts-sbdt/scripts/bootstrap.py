"""Generate local-only credentials and a Keycloak realm; never prints secrets."""
import json
import os
import secrets
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
KEYS=['POSTGRES_PASSWORD','APP_DB_PASSWORD','REPLICATION_PASSWORD',
      'KEYCLOAK_DB_PASSWORD','KEYCLOAK_ADMIN_PASSWORD','DEMO_PASSWORD',
      'OTHER_PASSWORD','GUEST_PASSWORD']

def read_env():
    path=ROOT/'.env'
    return dict(line.split('=',1) for line in path.read_text().splitlines() if line and not line.startswith('#'))

def main():
    env_path=ROOT/'.env'
    if env_path.exists():
        env=read_env()
    else:
        env={key:secrets.token_hex(20) for key in KEYS}
        env['API_IMAGE']='autogarage-uts:e2e'
        env_path.write_text('\n'.join(f'{k}={v}' for k,v in env.items())+'\n')
        env_path.chmod(0o600)
    audience={'name':'autogarage-api-audience','protocol':'openid-connect',
              'protocolMapper':'oidc-audience-mapper','consentRequired':False,
              'config':{'included.client.audience':'autogarage-api',
                        'access.token.claim':'true','id.token.claim':'false'}}
    web={'clientId':'autogarage-web','publicClient':True,'enabled':True,
         'standardFlowEnabled':True,'directAccessGrantsEnabled':False,
         'redirectUris':['http://api.lokal:8080/demo'],
         'webOrigins':['http://api.lokal:8080'],
         'attributes':{'pkce.code.challenge.method':'S256'},'protocolMappers':[audience]}
    ci={'clientId':'autogarage-ci','publicClient':True,'enabled':True,
        'standardFlowEnabled':False,'directAccessGrantsEnabled':True,
        'protocolMappers':[audience]}
    wrong={'clientId':'wrong-audience','publicClient':True,'enabled':True,
           'standardFlowEnabled':False,'directAccessGrantsEnabled':True}
    users=[]
    for username,password,first,last,roles in [
        ('ifan',env['DEMO_PASSWORD'],'Ifan Agung','Arisadi',['autogarage_user']),
        ('penguji',env['OTHER_PASSWORD'],'Akun','Penguji',['autogarage_user']),
        ('tamu',env['GUEST_PASSWORD'],'Akun','Tamu',[]),
    ]:
        users.append({'username':username,'enabled':True,'emailVerified':True,
            'email':username+'@example.test','firstName':first,'lastName':last,
            'requiredActions':[],'realmRoles':roles,
            'credentials':[{'type':'password','value':password,'temporary':False}]})
    realm={'realm':'autogarage','displayName':'201 Auto Garage | SSO',
           'enabled':True,'sslRequired':'none','registrationAllowed':False,
           'accessTokenLifespan':600,'roles':{'realm':[{'name':'autogarage_user'}]},
           'clients':[web,ci,wrong],'users':users}
    path=ROOT/'keycloak/realm.generated.json'
    path.parent.mkdir(exist_ok=True)
    path.write_text(json.dumps(realm,indent=2));path.chmod(0o600)
    # Keycloak UID 1000 must read this bind mount on a Linux lab host.
    path.chmod(0o644)
    print('Generated .env and local realm (credentials not displayed).')

if __name__=='__main__':main()
