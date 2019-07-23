. env.sh

echo
cyan "Running: $0: Enable/configure database engine"
pe "vault secrets enable -path=${DB_PATH} database"

green "Configure the account that Vault will use to manage credentials in Postgres."
cat << EOF
vault write ${DB_PATH}/config/${PGDATABASE}
    plugin_name=postgresql-database-plugin
    allowed_roles=*
    connection_url="postgresql://{{username}}:{{password}}@${IP_ADDRESS}:${PGPORT}/${PGDATABASE}?sslmode=disable"
    username="${VAULT_ADMIN_USER}"
    password="${VAULT_ADMIN_PW}"
EOF
p
vault write ${DB_PATH}/config/${PGDATABASE} \
    plugin_name=postgresql-database-plugin \
    allowed_roles=* \
    connection_url="postgresql://{{username}}:{{password}}@${IP_ADDRESS}:${PGPORT}/${PGDATABASE}?sslmode=disable" \
    username="${VAULT_ADMIN_USER}" \
    password="${VAULT_ADMIN_PW}"

#green "Rotate the credentials for ${VAULT_ADMIN_USER} so no human has access to them anymore"
#pe "vault write -force ${DB_PATH}/rotate-root/${PGDATABASE}"

green "Configure the Vault/Postgres database roles with time bound credential templates"
yellow "There are 1m and 1h credential endpoints.  1m are great for demo'ing so you can see them expire"
echo
green "Full read can be used by security teams to scan for credentials in any schema"
cat << EOF
vault write ${DB_PATH}/roles/${PGDATABASE}-full-read-1m
    db_name=${PGDATABASE}
    creation_statements="CREATE ROLE "{{name}}" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT USAGE ON SCHEMA public,it,hr,security,finance,engineering TO \"{{name}}\"; GRANT SELECT ON ALL TABLES IN SCHEMA public,it,hr,security,finance,engineering TO "{{name}}";"
    default_ttl=1m
    max_ttl=24h
EOF
p

vault write ${DB_PATH}/roles/${PGDATABASE}-full-read-1m \
    db_name=${PGDATABASE} \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT USAGE ON SCHEMA public,it,hr,security,finance,engineering TO \"{{name}}\"; GRANT SELECT ON ALL TABLES IN SCHEMA public,it,hr,security,finance,engineering TO \"{{name}}\";" \
    default_ttl=1m \
    max_ttl=24h


cat << EOF
vault write ${DB_PATH}/roles/${PGDATABASE}-full-read-1h
    db_name=${PGDATABASE}
    creation_statements="CREATE ROLE "{{name}}" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT USAGE ON SCHEMA public,it,hr,security,finance,engineering TO \"{{name}}\"; GRANT SELECT ON ALL TABLES IN SCHEMA public,it,hr,security,finance,engineering TO "{{name}}";"
    default_ttl=1h
    max_ttl=24h
EOF
p

vault write ${DB_PATH}/roles/${PGDATABASE}-full-read-1h \
    db_name=${PGDATABASE} \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT USAGE ON SCHEMA public,it,hr,security,finance,engineering TO \"{{name}}\"; GRANT SELECT ON ALL TABLES IN SCHEMA public,it,hr,security,finance,engineering TO \"{{name}}\";" \
    default_ttl=1h \
    max_ttl=24h

echo
green "HR will only be granted full access to their schema"
cat << EOF
vault write ${DB_PATH}/roles/${PGDATABASE}-hr-full-1m
    db_name=${PGDATABASE}
    creation_statements="CREATE ROLE "{{name}}" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT USAGE ON SCHEMA hr TO \"{{name}}\"; GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA hr TO "{{name}}";"
    default_ttl=1m
    max_ttl=24h
EOF
p

vault write ${DB_PATH}/roles/${PGDATABASE}-hr-full-1m \
    db_name=${PGDATABASE} \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT USAGE ON SCHEMA hr TO \"{{name}}\"; GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA hr TO \"{{name}}\";" \
    default_ttl=1m \
    max_ttl=24h

cat << EOF
vault write ${DB_PATH}/roles/${PGDATABASE}-hr-full-1h
    db_name=${PGDATABASE}
    creation_statements="CREATE ROLE "{{name}}" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT USAGE ON SCHEMA hr TO \"{{name}}\"; GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA hr TO "{{name}}";"
    default_ttl=1h
    max_ttl=24h
EOF
p

vault write ${DB_PATH}/roles/${PGDATABASE}-hr-full-1h \
    db_name=${PGDATABASE} \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT USAGE ON SCHEMA hr TO \"{{name}}\"; GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA hr TO \"{{name}}\";" \
    default_ttl=1h \
    max_ttl=24h

echo
green "Engineering will be given full access to their schema"
cat << EOF
vault write ${DB_PATH}/roles/${PGDATABASE}-engineering-full-1m
    db_name=${PGDATABASE}
    creation_statements="CREATE ROLE "{{name}}" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT USAGE ON SCHEMA engineering TO \"{{name}}\"; GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA engineering TO "{{name}}";"
    default_ttl=1m
    max_ttl=24h
EOF
p

vault write ${DB_PATH}/roles/${PGDATABASE}-engineering-full-1m \
    db_name=${PGDATABASE} \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT USAGE ON SCHEMA engineering TO \"{{name}}\"; GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA engineering TO \"{{name}}\";" \
    default_ttl=1m \
    max_ttl=24h

cat << EOF
vault write ${DB_PATH}/roles/${PGDATABASE}-engineering-full-1h
    db_name=${PGDATABASE}
    creation_statements="CREATE ROLE "{{name}}" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT USAGE ON SCHEMA engineering TO \"{{name}}\"; GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA engineering TO "{{name}}";"
    default_ttl=1h
    max_ttl=24h
EOF
p

vault write ${DB_PATH}/roles/${PGDATABASE}-engineering-full-1h \
    db_name=${PGDATABASE} \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT USAGE ON SCHEMA engineering TO \"{{name}}\"; GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA engineering TO \"{{name}}\";" \
    default_ttl=1h \
    max_ttl=24h
