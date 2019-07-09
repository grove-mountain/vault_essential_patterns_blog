shopt -s expand_aliases

. env.sh


green "Logging in with the memberOf overlay, notice the path difference"
yellow "Ensure the root token isn't being used"
pe "unset VAULT_TOKEN"
pe "vault login -method=ldap -path=ldap-mo username=chun password=${USER_PASSWORD}"

green "Read out the dynamic DB credentials and store them as variables"
echo
green "Getting dynamic db credentials from Vault. There are more elegant ways of doing this, but this shows the process well"
pe "vault read -format=json db-blog/creds/mother-engineering-full-1m | jq -r '.data | to_entries | .[] | .key + \"=\" + .value ' > temp_creds"
pe ". temp_creds"
# pe "eval $(vault read -format=json db-blog/creds/mother-engineering-full-1m | jq -r '.data | to_entries | .[] | .key + "=" + .value ')"

green "Turn off globbing for the database query in an environment variable"
pe "set -o noglob"
pe "QUERY='select * from engineering.catalog;'"

green "By setting the postgres environment variables to the dynamic creds, we can run PSQL with those dynamic creds"
yellow "username=$username"
yellow "password=$password"
pe "PGUSER=\$username PGPASSWORD=\$password psql"


