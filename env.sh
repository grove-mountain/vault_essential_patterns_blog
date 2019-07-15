# This probably only works on Macs, so will have to be adjusted for other systems
export IP_ADDRESS=$(ipconfig getifaddr en0)

export VAULT_ADDR="http://${IP_ADDRESS}:8200"
export VAULT_TOKEN=${VAULT_ROOT_TOKEN:-"notsosecure"}

# Dev server environment variables
export VAULT_DEV_LISTEN_ADDRESS="${IP_ADDRESS}:8200"
export VAULT_DEV_ROOT_TOKEN_ID=${VAULT_TOKEN}

export VAULT_ADMIN_USER=vault_admin
export VAULT_ADMIN_PW=notsosecure
export DYNAMIC_DEFAULT_TTL="${DYNAMIC_DEFAULT_TTL:-1m}"
export DYNAMIC_MAX_TTL="24h"

export PGHOST=${IP_ADDRESS}
export PGPORT=5432
export PGDATABASE=mother
export PGUSER=postgres
export PGPASSWORD=1234

export KV_PATH=kv-blog
export KV_VERSION=2
export TRANSIT_PATH=transit-blog
export DB_PATH=db-blog

# LDAP Server settings
export LDAP_HOST=${LDAP_HOST:-${IP_ADDRESS}}
export LDAP_URL="ldap://${LDAP_HOST}"
export LDAP_ORGANISATION=${LDAP_ORGANISATION:-"OurCorp Inc"}
export LDAP_DOMAIN=${LDAP_DOMAIN:-"ourcorp.com"}
export LDAP_HOSTNAME=${LDAP_HOSTNAME:-"ldap.ourcorp.com"}
export LDAP_READONLY_USER=${LDAP_READONLY_USER:-true}
export LDAP_READONLY_USER_USERNAME=${LDAP_READONLY_USER_USERNAME:-read-only}
export LDAP_READONLY_USER_PASSWORD=${LDAP_READONLY_USER_PASSWORD:-"devsecopsFTW"}
export LDAP_ADMIN_PASSWORD=${LDAP_ADMIN_PASSWORD:-"hashifolk"}


# LDAP Connect settings
export BIND_DN=${BIND_DN:-"cn=read-only,dc=ourcorp,dc=com"}
export BIND_PW=${BIND_PW:-"devsecopsFTW"}
export USER_DN=${USER_DN:-"ou=people,dc=ourcorp,dc=com"}
export USER_ATTR=${USER_ATTR:-"cn"}
export GROUP_DN=${GROUP_DN:-"ou=um_group,dc=ourcorp,dc=com"}
export UM_GROUP_FILTER=${UM_GROUP_FILTER:-"(&(objectClass=groupOfUniqueNames)(uniqueMember={{.UserDN}}))"}
export UM_GROUP_ATTR=${UM_GROUP_ATTR:-"cn"}
export MO_GROUP_FILTER=${MO_GROUP_FILTER:-"(&(objectClass=person)(uid={{.Username}}))"}
export MO_GROUP_ATTR=${MO_GROUP_ATTR:-"memberOf"}
# This is the default user password created by the default ldif creator if none other is specified
export USER_PASSWORD=${USER_PASSWORD:-"thispasswordsucks"}

# For running psql from the postgres docker container.  
# Why an alias?  Try running this as a function with quoted strings as arguments
alias psql='docker run --rm -it --entrypoint=/usr/bin/psql -e COLUMNS=${PGCOLUMNS} -e PGHOST=${PGHOST} -e PGDATABASE=${PGDATABASE} -e PGUSER=${PGUSER} -e PGPASSWORD=${PGPASSWORD} postgres -c "${QUERY}" ${PG_OPTIONS}'

# This is for the time to wait when using demo_magic.sh
if [[ -z ${DEMO_WAIT} ]];then
  DEMO_WAIT=0
fi

# Demo magic gives wrappers for running commands in demo mode.   Also good for learning via CLI.

. demo-magic.sh -d -p -w ${DEMO_WAIT}
