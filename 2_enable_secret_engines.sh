. env.sh

pe "vault secrets enable -path=${KV_PATH} -version=${KV_VERSION} kv"

pe "vault secrets enable -path=${TRANSIT_PATH} transit"

pe "vault secrets enable -path=${DB_PATH} database"
