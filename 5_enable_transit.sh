. env.sh

echo
cyan "Running: $0: Enable/configure the Transit Secret Engine (Encryption as a Service)"
pe "vault secrets enable -path=${TRANSIT_PATH} transit"

green "Create a transit key for the HR team."
pe "vault write -f ${TRANSIT_PATH}/keys/hr"
