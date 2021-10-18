#!/bin/sh
docker run -e POSTGRES_DB=nextcloud -e POSTGRES_USER=nextcloud -e POSTGRES_PASSWORD=NSSCloud --name post -v "$(pwd)/server.crt:/var/lib/postgresql/server.crt:ro" -v "$(pwd)/server.key:/var/lib/postgresql/server.key:ro" -v /var/lib/postgresql/data:/var/lib/postgresql/data -p 5432 --memory="384m" --memory-reservation="256m" --memory-swap="768m" --cpus=".5" --restart always -d postgres:latest -c ssl=on -c ssl_cert_file=/var/lib/postgresql/server.crt -c ssl_key_file=/var/lib/postgresql/server.key

