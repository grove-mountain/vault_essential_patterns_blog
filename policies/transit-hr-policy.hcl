path "transit-blog/keys/hr" {
  capabilities = [ "read" ]
}

path "transit-blog/encrypt/hr" {
  capabilities = [ "create", "read" ]
}

path "transit-blog/decrypt/hr" {
  capabilities = [ "read" ]
}
