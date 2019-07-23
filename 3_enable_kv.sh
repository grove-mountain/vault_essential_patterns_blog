. env.sh

echo
cyan "Running: $0: Enabling KV Secret Engine"
green "Enable the KV V2 Secret Engine"
pe "vault secrets enable -path=${KV_PATH} -version=${KV_VERSION} kv"
