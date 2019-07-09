shopt -s expand_aliases

. env.sh

green "Logging in with the memberOf overlay, notice the path difference"
yellow "Ensure the root token isn't being used"
pe "unset VAULT_TOKEN"
pe "vault login -method=ldap -path=ldap-mo username=frank password=${USER_PASSWORD}"

green "Read out the dynamic DB credentials and store them as variables"
echo
green "Getting dynamic db credentials from Vault. There are more elegant ways of doing this, but this shows the process well"
pe "vault read -format=json db-blog/creds/mother-hr-full-1h | jq -r '.data | to_entries | .[] | .key + \"=\" + .value ' > temp_creds"
pe ". temp_creds"

green "Turn off globbing for the database query in an environment variable (This won't be displayed in subsequent glob requests)"
pe "set -o noglob"
pe "QUERY='select * from hr.people;'"
pe "set +o noglob"

green "By setting the postgres environment variables to the dynamic creds, we can run PSQL with those dynamic creds"
yellow "username=$username"
yellow "password=$password"
pe "PGUSER=\$username PGPASSWORD=\$password psql"



green "Find an existing user id and encrypt it"
yellow "WARNING!   When doing this in production, it's best to schedule a maintenance window unless your application logic can consume both encrypted and unencrypted values"
echo
pe "QUERY=\"select id from hr.people where email='alice@ourcorp.com'\""
export PG_OPTIONS="-A -t"
pe "user_id=\$(psql)"
echo "user_id = ${user_id}"
export PG_OPTIONS=""

pe "enc_id=\$(vault write -field=ciphertext transit-blog/encrypt/hr plaintext=\$( base64 <<< \${user_id} ) )"

pe "QUERY=\"UPDATE hr.people SET id='${enc_id}' WHERE email='alice@ourcorp.com'\""
pe "psql"

# Turn off headings and aligned output
set -o noglob
pe "QUERY=\"select * from hr.people\""
pe "psql"
set +o noglob

green "This is the process your applications will use when data is encrypted with Vault"
pe "QUERY=\"select id from hr.people where email='alice@ourcorp.com'\""
export PG_OPTIONS="-A -t"
pe "enc_user_id=\$(psql)"
echo "enc_user_id = ${enc_user_id}"
export PG_OPTIONS=""

pe "user_id=\$(vault write -field=plaintext transit-blog/decrypt/hr ciphertext=${enc_user_id} | base64 --decode)"
pe "echo \${user_id}"

green "Notice the value is still encrypted in the database.   It should only decrypted by your applications when needed to be displayed"
set -o noglob
pe "QUERY=\"select * from hr.people\""
pe "psql"
set +o noglob

yellow "If you want to re-run this demo, you should restart the database: docker kill postgres && ./1_init_db.sh"
