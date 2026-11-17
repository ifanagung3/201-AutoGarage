"""Real HTTP/SQL/cluster checks. Never substitutes mocks for integration evidence."""
import argparse
import json
import os
import subprocess
import platform
import time
from datetime import datetime, timezone
from pathlib import Path
import requests
from bootstrap import ROOT, read_env

BASE='http://api.lokal:8080'
AUTH='http://auth.lokal:8080/realms/autogarage'
PAYLOAD={'car_brand':'Toyota','car_model':'Avanza','car_year':2018,
         'service_type':'Tune Up','mileage':75000,'component_count':5}
session=requests.Session();session.trust_env=False

def command(args,check=True):
    result=subprocess.run(args,cwd=ROOT,capture_output=True,text=True,timeout=240)
    if check and result.returncode:
        raise RuntimeError('Command failed: '+' '.join(args)+'\n'+result.stdout+result.stderr)
    return result

def wait_until(action,description,seconds=180):
    deadline=time.monotonic()+seconds
    last=None
    while time.monotonic()<deadline:
        try:
            result=action()
            if result:return result
        except Exception as exc:last=str(exc)
        time.sleep(2)
    raise AssertionError(f'Timeout: {description}; {last}')

def token(env,username='ifan',client='autogarage-ci'):
    password=env[{'ifan':'DEMO_PASSWORD','penguji':'OTHER_PASSWORD','tamu':'GUEST_PASSWORD'}[username]]
    response=session.post(AUTH+'/protocol/openid-connect/token',data={
        'grant_type':'password','client_id':client,'username':username,'password':password},timeout=15)
    if response.status_code!=200:
        raise AssertionError(f'SSO token request failed ({response.status_code}); {response.json().get("error")}')
    return response.json()['access_token']

def headers(access_token):return {'Authorization':'Bearer '+access_token}

def sql(mode,service,statement,check=True):
    args=(['docker','compose','exec','-T',service] if mode=='compose' else
          ['kubectl','-n','autogarage','exec',service+'-0','--'])
    return command(args+['psql','-v','ON_ERROR_STOP=1','-U','postgres','-d','autogarage','-At','-c',statement],check)

def sql_json(mode,service,statement):
    wrapped="SELECT coalesce(json_agg(t),'[]'::json)::text FROM ("+statement+") t"
    return json.loads(sql(mode,service,wrapped).stdout)

def main(mode):
    env=read_env();out=ROOT/'evidence';out.mkdir(exist_ok=True)
    git_args=['git','-c','safe.directory='+str(ROOT.parent)]
    report={'environment':mode,'source_sha':os.getenv('GITHUB_SHA') or command(git_args+['rev-parse','HEAD']).stdout.strip(),
            'source_dirty':bool(command(git_args+['status','--porcelain','--untracked-files=no']).stdout.strip()),
            'runtime':platform.platform(),
            'run_url':('https://github.com/'+os.getenv('GITHUB_REPOSITORY','ifanagung3/201-AutoGarage')+'/actions/runs/'+os.environ['GITHUB_RUN_ID']) if os.getenv('GITHUB_RUN_ID') else None,
            'started_at':datetime.now(timezone.utc).isoformat(),'checks':[]}
    def passed(name,observed):
        report['checks'].append({'name':name,'passed':True,'observed':observed})
        print('PASS',name,json.dumps(observed,default=str),flush=True)
    try:
        wait_until(lambda:session.get(BASE+'/ready',timeout=10).status_code==200,'API readiness')
        wait_until(lambda:session.get(AUTH+'/.well-known/openid-configuration',timeout=10).status_code==200,'OIDC discovery')
        discovery=session.get(AUTH+'/.well-known/openid-configuration',timeout=15).json()
        assert discovery['issuer']==AUTH
        passed('Readiness and OIDC discovery',{'issuer':discovery['issuer'],'ready':200})
        access=token(env)
        me=session.get(BASE+'/me',headers=headers(access),timeout=15)
        assert me.status_code==200
        passed('Keycloak access token accepted via JWKS',me.json())
        no_token=session.post(BASE+'/predict',json=PAYLOAD,timeout=15)
        assert no_token.status_code==401
        bad=session.post(BASE+'/predict',json=PAYLOAD,headers=headers(access[:-8]+'invalid!'),timeout=15)
        assert bad.status_code==401
        wrong=session.get(BASE+'/history',headers=headers(token(env,client='wrong-audience')),timeout=15)
        assert wrong.status_code==401
        guest=session.get(BASE+'/history',headers=headers(token(env,'tamu')),timeout=15)
        assert guest.status_code==403
        passed('Authentication and authorization rejection',{'missing':401,'invalid_signature':401,'wrong_audience':401,'missing_role':403})
        invalid=session.post(BASE+'/predict',json={**PAYLOAD,'mileage':-1},headers=headers(access),timeout=15)
        forged=session.post(BASE+'/predict',json={**PAYLOAD,'user_id':'another-user'},headers=headers(access),timeout=15)
        assert invalid.status_code==422 and forged.status_code==422
        passed('Input and owner spoofing rejected',{'negative_mileage':422,'extra_user_id':422})
        prediction=session.post(BASE+'/predict',json=PAYLOAD,headers=headers(access),timeout=30)
        assert prediction.status_code==200,prediction.text
        assert prediction.headers.get('X-Database-Role')=='primary'
        value=prediction.json();record_id=int(value['id'])
        assert value['estimated_cost']>0 and value['estimated_duration']>0
        passed('Real model inference committed on primary',{'response':value,'database_header':prediction.headers['X-Database-Role']})
        def find_history():
            r=session.get(BASE+'/history',headers=headers(access),timeout=15)
            if r.status_code==200 and any(item['id']==record_id for item in r.json()['items']):return r
        history=wait_until(find_history,'replica WAL replay',60)
        assert history.headers.get('X-Database-Role')=='replica'
        record=next(item for item in history.json()['items'] if item['id']==record_id)
        passed('History read from replica',{'database_header':'replica','record':record})
        other=session.get(BASE+'/history',headers=headers(token(env,'penguji')),timeout=15)
        assert other.status_code==200 and all(item['id']!=record_id for item in other.json()['items'])
        passed('Cross-user history isolated',{'other_user_visible_ids':[item['id'] for item in other.json()['items']]})
        db={}
        for service in ['postgres-primary','postgres-replica']:
            db[service]={'identity':sql_json(mode,service,'SELECT pg_is_in_recovery() AS in_recovery, version() AS server_version'),
                         'record':sql_json(mode,service,f'SELECT id,user_id,estimated_cost,estimated_duration,model_version FROM inference_history WHERE id={record_id}')}
        assert db['postgres-primary']['identity'][0]['in_recovery'] is False
        assert db['postgres-replica']['identity'][0]['in_recovery'] is True
        assert db['postgres-primary']['record']==db['postgres-replica']['record']
        db['streaming']=sql_json(mode,'postgres-primary','SELECT application_name,state,sync_state FROM pg_stat_replication')
        assert any(row['state']=='streaming' for row in db['streaming'])
        passed('Direct SQL replication proof',db)
        rejection=sql(mode,'postgres-replica','BEGIN; SET TRANSACTION READ WRITE;',check=False)
        assert rejection.returncode!=0 and 'read-write' in rejection.stderr
        passed('Standby rejects write transaction',{'returncode':rejection.returncode,'stderr':rejection.stderr.strip()})
        if mode=='kubernetes':
            pod=lambda:json.loads(command(['kubectl','-n','autogarage','get','pod','postgres-primary-0','-o','json']).stdout)
            pvc=lambda:json.loads(command(['kubectl','-n','autogarage','get','pvc','pgdata-postgres-primary-0','-o','json']).stdout)
            before_pod=pod();before_pvc=pvc()
            command(['kubectl','-n','autogarage','delete','pod','postgres-primary-0','--wait=true'])
            def new_pod_ready():
                p=pod()
                if p['metadata']['uid']==before_pod['metadata']['uid']:return None
                if any(c['type']=='Ready' and c['status']=='True' for c in p['status'].get('conditions',[])):return p
            after_pod=wait_until(new_pod_ready,'replacement primary pod ready',180)
            after_pvc=pvc()
            assert before_pvc['metadata']['uid']==after_pvc['metadata']['uid']
            assert before_pvc['spec']['volumeName']==after_pvc['spec']['volumeName']
            survived=sql_json(mode,'postgres-primary',f'SELECT id,estimated_cost,model_version FROM inference_history WHERE id={record_id}')
            assert survived and survived[0]['id']==record_id
            passed('Primary pod deletion preserves record and PVC',{
                'pod_uid_before':before_pod['metadata']['uid'],'pod_uid_after':after_pod['metadata']['uid'],
                'pvc_uid_before':before_pvc['metadata']['uid'],'pvc_uid_after':after_pvc['metadata']['uid'],
                'pv_before':before_pvc['spec']['volumeName'],'pv_after':after_pvc['spec']['volumeName'],
                'record_after':survived})
            wait_until(lambda:session.get(BASE+'/ready',timeout=10).status_code==200,'API recovery')
            access=wait_until(lambda:token(env),'SSO database reconnection',60)
            after=session.post(BASE+'/predict',json=PAYLOAD,headers=headers(access),timeout=30)
            assert after.status_code==200,after.text
            post_id=after.json()['id']
            wait_until(lambda:bool(sql_json(mode,'postgres-replica',f'SELECT id FROM inference_history WHERE id={int(post_id)}')),'replication after restart',60)
            passed('Writes and replication recover after restart',{'new_record_id':post_id,'status':200})
            snapshot=command(['kubectl','-n','autogarage','get','pods,sts,svc,pvc,ingress','-o','wide']).stdout
        else:
            snapshot=command(['docker','compose','ps']).stdout
        (out/f'{mode}-resources.txt').write_text(snapshot)
        print(snapshot)
        report['passed']=True
    except Exception as exc:
        report['passed']=False;report['error']=str(exc)
        raise
    finally:
        report['finished_at']=datetime.now(timezone.utc).isoformat()
        (out/f'{mode}-results.json').write_text(json.dumps(report,indent=2,default=str))

if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('mode',choices=['compose','kubernetes'])
    main(parser.parse_args().mode)
