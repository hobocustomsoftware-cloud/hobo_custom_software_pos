# Run from project root: .\deploy\server\run.ps1
Set-Location $PSScriptRoot\..
docker-compose -f deploy/server/docker-compose.yml --env-file deploy/server/.env up -d
