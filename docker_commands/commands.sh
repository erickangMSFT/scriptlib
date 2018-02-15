#!/bin/bash

docker exec -i -t <container_id / name> /bin/bash
docker cp <host filename> <continer_id/name>:/var/opt/mssql/backup
