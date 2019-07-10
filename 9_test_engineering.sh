shopt -s expand_aliases

. env.sh

unset PGUSER PGPASSWORD
USERNAME=chun

green "Logging in with the memberOf overlay, notice the path difference"
yellow "Ensure the root token isn't being used"
pe "unset VAULT_TOKEN"
pe "vault login -method=ldap -path=ldap-mo username=${USERNAME} password=${USER_PASSWORD}"

green "Read out the dynamic DB credentials and store them as variables"
echo
green "Getting dynamic db credentials from Vault. There are more elegant ways of doing this, but this shows the process well"
pe "vault read -format=json db-blog/creds/mother-engineering-full-1h | jq -r '.data | to_entries | .[] | .key + \"=\" + .value ' > temp_creds"
pe ". temp_creds"
# pe "eval $(vault read -format=json db-blog/creds/mother-engineering-full-1h | jq -r '.data | to_entries | .[] | .key + "=" + .value ')"

green "By setting the postgres environment variables to the dynamic creds, we can run PSQL with those dynamic creds"
pe "export PGUSER=$username PGPASSWORD=$password"

green "Turn off globbing for the database query in an environment variable"
pe "set -o noglob"
pe "QUERY='select * from engineering.catalog;'"
pe "psql"

green "Use the dynamic ACL policy to write to a KV location under this user name"
pe "vault kv put ${KV_PATH}/${USERNAME}/passwords laptop=legleglegleg cameras=bigbagofnope"
pe "vault kv get ${KV_PATH}/${USERNAME}/passwords"

green "Negative Tests. Expect failures"
yellow "Can these credentials be used to query the HR schema?"
pe "QUERY='select * from hr.people;'"
pe "psql"

yellow "Can the Vault token read from other areas?"
pe "vault read db-blog/creds/mother-full-read-1h"
pe "vault kv get kv-blog/it/servers/hr/root"
