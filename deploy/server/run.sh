#!/bin/bash
# Run from project root: ./deploy/server/run.sh
cd "$(dirname "$0")/../.."
docker-compose -f deploy/server/docker-compose.yml --env-file deploy/server/.env up -d
