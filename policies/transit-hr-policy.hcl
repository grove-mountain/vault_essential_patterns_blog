path "transit-blog/keys/hr" {
  capabilities = [ "read" ]
}

path "transit-blog/encrypt/hr" {
  capabilities = [ "create", "read", "update" ]
}

path "transit-blog/decrypt/hr" {
  capabilities = [ "create", "read", "update" ]
}
