. env.sh

# KV Policies
pe "vault policy write kv-it policies/kv-it-policy.hcl"

# DB Policies
pe "vault policy write db-full-read policies/db-full-read-policy.hcl"
pe "vault policy write db-engineering policies/db-engineering-policy.hcl"
pe "vault policy write db-hr policies/db-hr-policy.hcl"

# Transit Policies
pe "vault policy write transit-hr policies/db-hr-policy.hcl"
