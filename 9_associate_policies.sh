. env.sh

echo
cyan "Running: $0: Associating Policies with Authentication Methods"
# Unique Member configs
green "Setup Unique Member group logins for LDAP.   These can use alias names when logging in"
echo
pe "vault write auth/ldap-um/groups/it policies=kv-it,kv-user-template"
pe "vault write auth/ldap-um/groups/security policies=db-full-read,kv-user-template"

# MemberOf configs
green "Setup MemberOf group logins for LDAP.   Need to use the entire DN for the group here as these are in the user's attributes"
echo
pe "vault write auth/ldap-mo/groups/cn=hr,ou=um_group,dc=ourcorp,dc=com policies=db-hr,transit-hr,kv-user-template"
pe "vault write auth/ldap-mo/groups/cn=engineering,ou=um_group,dc=ourcorp,dc=com policies=db-engineering,kv-user-template"
