import subprocess
from pathlib import Path
from bootstrap import ROOT, read_env

def run(args,**kw):return subprocess.run(args,check=True,**kw)

def main():
    env=read_env()
    run(['kubectl','create','namespace','autogarage'])
    keys=['POSTGRES_PASSWORD','APP_DB_PASSWORD','REPLICATION_PASSWORD','KEYCLOAK_DB_PASSWORD','KEYCLOAK_ADMIN_PASSWORD']
    # --from-file stdin avoids putting passwords in process arguments or logs.
    content=''.join(f'{key}={env[key]}\n' for key in keys)
    run(['kubectl','-n','autogarage','create','secret','generic','app-secrets','--from-env-file=/dev/stdin'],input=content,text=True)
    run(['kubectl','-n','autogarage','create','secret','generic','keycloak-realm',
         '--from-file=realm.json='+str(ROOT/'keycloak/realm.generated.json')])
    run(['kubectl','-n','autogarage','create','configmap','database-scripts',
         '--from-file='+str(ROOT/'database/init-primary.sh'),
         '--from-file='+str(ROOT/'database/start-replica.sh'),
         '--from-file='+str(ROOT/'database/001_schema.sql')])
    for path in ['workloads.yaml','ingress.yaml']:
        run(['kubectl','apply','-f',str(ROOT/'kubernetes'/path)])
    for resource in ['statefulset/postgres-primary','statefulset/postgres-replica',
                     'deployment/keycloak','deployment/backend','deployment/ingress']:
        run(['kubectl','-n','autogarage','rollout','status',resource,'--timeout=360s'])

if __name__=='__main__':main()
