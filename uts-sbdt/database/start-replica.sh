#!/usr/bin/env bash
set -Eeuo pipefail
export PGDATA="${PGDATA:-/var/lib/postgresql/data/pgdata}"
if [ "$(id -u)" = 0 ]; then
  mkdir -p "$PGDATA"
  chown -R postgres:postgres /var/lib/postgresql/data
  exec gosu postgres bash "$0"
fi
umask 077
printf 'postgres-primary:5432:replication:replicator:%s\n' "$REPLICATION_PASSWORD" > /tmp/replica.pgpass
export PGPASSFILE=/tmp/replica.pgpass
if [ ! -s "$PGDATA/PG_VERSION" ]; then
  staging="${PGDATA}.bootstrap"
  for attempt in $(seq 1 60); do
    rm -rf "$staging"
    if pg_basebackup -h postgres-primary -U replicator -D "$staging" -X stream -R; then
      rmdir "$PGDATA"
      mv "$staging" "$PGDATA"
      break
    fi
    sleep 3
  done
fi
test -s "$PGDATA/PG_VERSION"
cat >> "$PGDATA/postgresql.auto.conf" <<'PGCONF'
primary_conninfo = 'host=postgres-primary port=5432 user=replicator passfile=/tmp/replica.pgpass application_name=autogarage_replica'
hot_standby = on
PGCONF
touch "$PGDATA/standby.signal"
exec postgres -D "$PGDATA"
