# Kill docker containers
docker kill postgres openldap

# Kill the Vault dev server
kill $(ps | grep "vault server -dev" | grep -v grep | awk '{print $1}')
