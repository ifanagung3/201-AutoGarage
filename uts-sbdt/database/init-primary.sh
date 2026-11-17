#!/usr/bin/env bash
set -Eeuo pipefail
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
  --set=app_password="$APP_DB_PASSWORD" --set=repl_password="$REPLICATION_PASSWORD" \
  --set=kc_password="$KEYCLOAK_DB_PASSWORD" <<'SQL'
SELECT format('CREATE ROLE app_writer LOGIN PASSWORD %L', :'app_password') \gexec
SELECT format('CREATE ROLE app_reader LOGIN PASSWORD %L', :'app_password') \gexec
SELECT format('CREATE ROLE replicator LOGIN REPLICATION PASSWORD %L', :'repl_password') \gexec
SELECT format('CREATE ROLE keycloak LOGIN PASSWORD %L', :'kc_password') \gexec
CREATE DATABASE keycloak OWNER keycloak;
\i /opt/autogarage/001_schema.sql
SQL
# Private lab network only; credentials use SCRAM.
printf '\nhost replication replicator 0.0.0.0/0 scram-sha-256\n' >> "$PGDATA/pg_hba.conf"
