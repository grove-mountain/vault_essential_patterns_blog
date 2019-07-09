# KV V2 Blanket Policies:

# Allow full access to the current version of the kv-blog
path "kv-blog/data/it/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv-blog/data/it"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}


# Allow deletion of any kv-blog version
path "kv-blog/delete/it/*"
{
  capabilities = ["update"]
}

path "kv-blog/delete/it"
{
  capabilities = ["update"]
}

# Allow un-deletion of any kv-blog version
path "kv-blog/undelete/it/*"
{
  capabilities = ["update"]
}

path "kv-blog/undelete/it"
{
  capabilities = ["update"]
}

# Allow destroy of any kv-blog version
path "kv-blog/destroy/it/*"
{
  capabilities = ["update"]
}

path "kv-blog/destroy/it"
{
  capabilities = ["update"]
}
# Allow list and view of metadata and to delete all versions and metadata for a key
path "kv-blog/metadata/it/*"
{
  capabilities = ["list", "read", "delete"]
}

path "kv-blog/metadata/it"
{
  capabilities = ["list", "read", "delete"]
}
