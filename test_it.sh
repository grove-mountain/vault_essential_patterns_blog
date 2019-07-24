. env.sh

cyan "Running: $0: Testing IT requirements"
yellow "Unset VAULT_TOKEN so we don't accidentally carry over the root token"
pe "unset VAULT_TOKEN"
pe "vault login -method=ldap -path=ldap-um username=deepak password=${USER_PASSWORD}"

green "Test KV puts to allowed paths"
pe "vault kv put kv-blog/it/servers/hr/root password=rootntootn"
pe "vault kv put kv-blog/it/routers/snmp/read-write password=snortymcsnortyton"

green "This is allowed via an ACL templated path!"
pe "vault kv put kv-blog/deepak/email password=doesntlooklikeanythingtome"

green "Test KV gets to allowed paths"
pe "vault kv get kv-blog/it/servers/hr/root"
pe "vault kv get kv-blog/it/routers/snmp/read-write"
pe "vault kv get kv-blog/deepak/email"

green "Negative Tests. Expect failures"
echo
yellow "Test KV gets to disallowed paths"
pe "vault kv get kv-blog/hr/servers/hr/root" 
pe "vault kv get kv-blog/hr/routers/snmp/read-write"

yellow "Test KV puts to disallowed paths"
pe "vault kv put kv-blog/hr/servers/hr/root password=rootntootn"
pe "vault kv put kv-blog/hr/routers/snmp/read-write password=snortymcsnortyton"

yellow "Check against another user's path controlled by ACL templating"
pe "vault kv put kv-blog/alice/email password=doesntlooklikeanythingtome"

yellow "Test access to database endpoints"
pe "vault read db-blog/creds/mother-full-read-1m"
