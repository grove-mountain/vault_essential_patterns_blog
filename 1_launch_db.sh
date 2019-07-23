. env.sh

echo
cyan "Running: $0: Starting Postgres Database"

docker image inspect ${POSTGRES_IMAGE} &> /dev/null
[[ $? -eq 0 ]] || docker pull ${POSTGRES_IMAGE}
docker rm postgres &> /dev/null
docker run \
  --name postgres \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=${PGPASSWORD}  \
  -v ${PWD}/sql:/docker-entrypoint-initdb.d \
  -d ${POSTGRES_IMAGE}

echo "Database is running on ${PGHOST}:5432"
