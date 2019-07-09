# Place to park command tests that might be useful elsewhere.  Keeping in VCS for posterity

# Allow aliases in non-interactive scripts.   This works better than functions which will munge quotes in queries when passed to docker
shopt -s expand_aliases

# This alias expects the user to set these environment variables before running:
# PGHOST: The hostname or IP Address of the Postgres database.
# PGDATABASE: The database to run the query against
# PGUSER: The user to run the query of
# PGPASSWORD: The password for the PGUSER

alias psql='docker run --rm -it --entrypoint=/usr/bin/psql -e COLUMNS=${PGCOLUMNS} -e PGHOST=${PGHOST} -e PGDATABASE=${PGDATABASE} -e PGUSER=${PGUSER} -e PGPASSWORD=${PGPASSWORD} postgres -c "${QUERY}" ${PG_OPTIONS}'

# Prevents shell expansion of globs which will generally read in file names of ${PWD}.  Helpful for * in queries

set -o noglob
QUERY='select * from engineering.catalog;'
psql

QUERY='select * from hr.people;'
psql

# JSON Formatted output
# Should be used with -t -A options in psql to make formatting OK
# Also, COLUMNS setting for pty can affect output when redirected
QUERY='select json_agg(t) from (select * from hr.people) t;'
