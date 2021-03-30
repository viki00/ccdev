#!/bin/bash
set -u

# Copyright 2017 - 2020 Crunchy Data Solutions, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#$DIR/cleanup.sh

CONTAINER_NAME=postgres-gis-ha

echo "Starting the ${CONTAINER_NAME} example..."

VOLUME_NAME=${CONTAINER_NAME}-pgdata

docker volume create --driver local --name=$VOLUME_NAME

docker run \
	-p 12000:5432 \
	--privileged=true \
	--volume-driver=local \
	-v $VOLUME_NAME:/pgdata:z \
	-e TEMP_BUFFERS=9MB \
	-e PGHOST=/tmp \
	-e MAX_CONNECTIONS=101 \
	-e SHARED_BUFFERS=129MB \
	-e MAX_WAL_SENDERS=7 \
	-e WORK_MEM=5MB \
	-e PG_PRIMARY_USER=primaryuser \
	-e PG_PRIMARY_HOST=$CONTAINER_NAME \
	-e PG_PRIMARY_PORT=5432 \
	-e PG_PRIMARY_PASSWORD=password \
	-e PG_MODE=primary \
	-e PATRONI_SUPERUSER_USERNAME=testuser \
	-e PATRONI_SUPERUSER_PASSWORD=password \
	-e PATRONI_REPLICATION_USERNAME=testuser \
	-e PATRONI_REPLICATION_PASSWORD=password \
	-e PG_USER=testuser \
	-e PGHA_USER=testuser \
	-e PG_PASSWORD=password \
	-e PGHA_PASSWORD=password \
	-e PGHA_USER_PASSWORD=password \
	-e PG_ROOT_PASSWORD=password \
	-e PG_DATABASE=userdb \
	--name=$CONTAINER_NAME \
	--hostname=$CONTAINER_NAME \
	-d $CCP_IMAGE_PREFIX/crunchy-postgres-gis-ha:$CCP_POSTGIS_IMAGE_TAG
