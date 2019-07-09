. env.sh 

# Configure KV V2 engine

# Configure Transit engine

vault write -f ${TRANSIT_PATH}/keys/hr

# Configure database engine
vault write ${DB_PATH}/config/${PGDATABASE} \
    plugin_name=postgresql-database-plugin \
    allowed_roles=* \
    connection_url="postgresql://{{username}}:{{password}}@${IP_ADDRESS}:${PGPORT}/${PGDATABASE}?sslmode=disable" \
    username="${VAULT_ADMIN_USER}" \
    password="${VAULT_ADMIN_PW}"

vault write ${DB_PATH}/roles/${PGDATABASE}-full-read-1m \
    db_name=${PGDATABASE} \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT SELECT ON ALL TABLES IN SCHEMA public,it,hr,security,finance,engineering TO \"{{name}}\";" \
    default_ttl=1m \
    max_ttl=24h

vault write ${DB_PATH}/roles/${PGDATABASE}-full-read-1h \
    db_name=${PGDATABASE} \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT SELECT ON ALL TABLES IN SCHEMA public,it,hr,security,finance,engineering TO \"{{name}}\";" \
    default_ttl=1h \
    max_ttl=24h


vault write ${DB_PATH}/roles/${PGDATABASE}-hr-full-1m \
    db_name=${PGDATABASE} \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA hr TO \"{{name}}\";" \
    default_ttl=1m \
    max_ttl=24h

vault write ${DB_PATH}/roles/${PGDATABASE}-hr-full-1h \
    db_name=${PGDATABASE} \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA hr TO \"{{name}}\";" \
    default_ttl=1h \
    max_ttl=24h

vault write ${DB_PATH}/roles/${PGDATABASE}-engineering-full-1m \
    db_name=${PGDATABASE} \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA engineering TO \"{{name}}\";" \
    default_ttl=1m \
    max_ttl=24h

vault write ${DB_PATH}/roles/${PGDATABASE}-engineering-full-1h \
    db_name=${PGDATABASE} \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA engineering TO \"{{name}}\";" \
    default_ttl=1h \
    max_ttl=24h
