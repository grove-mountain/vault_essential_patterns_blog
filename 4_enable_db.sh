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

# DRYer?
write_db_role () {
ROLE=${PGDATABASE}-${ROLE_NAME}-${TTL}
cat << EOF
CREATION_STATEMENT=${CREATION_STATEMENT}

vault write ${DB_PATH}/roles/${ROLE}
    db_name=${PGDATABASE}
    creation_statements="$(echo ${CREATION_STATEMENT})"
    default_ttl=${TTL}
    max_ttl=${MAX_TTL}
EOF
p

vault write ${DB_PATH}/roles/${ROLE} \
    db_name=${PGDATABASE} \
    creation_statements="$(echo ${CREATION_STATEMENT})" \
    default_ttl=${TTL} \
    max_ttl=${MAX_TTL}
echo

}

green "Configure the Vault/Postgres database roles with time bound credential templates"
echo
yellow "There are 1m and 1h credential endpoints.  1m are great for demo'ing so you can see them expire"
echo

# Just set this here as all will likely use the same one
MAX_TTL=24h

green "Full read can be used by security teams to scan for credentials in any schema"
ROLE_NAME="full-read"
CREATION_STATEMENT="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
  GRANT USAGE ON SCHEMA public,it,hr,security,finance,engineering TO \"{{name}}\"; 
  GRANT SELECT ON ALL TABLES IN SCHEMA public,it,hr,security,finance,engineering TO \"{{name}}\";"
TTL=1m
write_db_role
TTL=1h
write_db_role

green "HR will be granted full access to their schema"
ROLE_NAME="hr-full"
CREATION_STATEMENT="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; 
GRANT USAGE ON SCHEMA hr TO \"{{name}}\"; 
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA hr TO \"{{name}}\";"
TTL=1m
write_db_role
TTL=1h
write_db_role

green "Engineering will be granted full access to their schema"
ROLE_NAME="engineering-full"
CREATION_STATEMENT="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; 
GRANT USAGE ON SCHEMA engineering TO \"{{name}}\"; 
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA engineering TO \"{{name}}\";"
TTL=1m
write_db_role
TTL=1h
write_db_role
