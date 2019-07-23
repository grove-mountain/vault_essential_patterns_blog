. env.sh

cyan "Running: $0: Testing IT requirements"
green "Unset VAULT_TOKEN so we don't accidentally carry over the root token"
pe "unset VAULT_TOKEN"
pe "vault login -method=ldap -path=ldap-um username=deepak password=${USER_PASSWORD}"

green "Test KV writes to allowed paths"
pe "vault kv put kv-blog/it/servers/hr/root password=rootntootn"
pe "vault kv put kv-blog/it/routers/snmp/read-write password=snortymcsnortyton"

green "Test KV reads to allowed paths"
pe "vault kv get kv-blog/it/servers/hr/root"
pe "vault kv get kv-blog/it/routers/snmp/read-write"

green "Negative Tests. Expect failures"
yellow "Test KV writes to disallowed paths"
pe "vault kv put kv-blog/hr/servers/hr/root password=rootntootn"
pe "vault kv put kv-blog/hr/routers/snmp/read-write password=snortymcsnortyton"

yellow "Test access to database endpoints"
pe "vault read db-blog/creds/mother-full-read-1m"
