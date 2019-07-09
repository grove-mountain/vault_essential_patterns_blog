. env.sh

#docker pull postgres
docker rm postgres &> /dev/null
docker run \
  --name postgres \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=${PGPASSWORD}  \
  -v ${PWD}/sql:/docker-entrypoint-initdb.d \
  -d postgres

echo "Database is running on ${PGHOST}:5432"
