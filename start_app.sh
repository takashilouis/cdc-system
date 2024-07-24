#!/bin/bash
docker compose -f docker-compose-server.yaml down
docker network create crawler
docker compose -f docker-compose-server.yaml up -d
curl -sOL https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh
chmod +x wait-for-it.sh
./wait-for-it.sh -t 0 localhost:5432 -- echo "postgres up"
./wait-for-it.sh -t 0 localhost:8083 -- echo "kafka connect up"
sleep 60
docker run --env-file=./migrate/.env.container --net crawler hero2510/migrate-app /app/run init
docker run --env-file=./migrate/.env.container --net crawler hero2510/migrate-app /app/run migrate
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @configs/connector/postgres-source.json 
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @configs/connector/elasticsearch-sink.json 