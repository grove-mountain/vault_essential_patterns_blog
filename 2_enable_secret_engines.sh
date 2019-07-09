. env.sh

vault secrets enable -path=${KV_PATH} -version=${KV_VERSION} kv

vault secrets enable -path=${TRANSIT_PATH} transit

vault secrets enable -path=${DB_PATH} database
