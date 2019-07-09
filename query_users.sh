shopt -s expand_aliases

. env.sh

pe "QUERY='select * from pg_user;' psql"
