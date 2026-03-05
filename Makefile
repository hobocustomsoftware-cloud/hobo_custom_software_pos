# HoBo POS - Run from repo root. Uses .env from root when present.
COMPOSE_FILE := compose/docker-compose.server.yml
ENV_FILE := --env-file .env

# Use .env if it exists
ifeq ($(shell test -f .env && echo yes),yes)
  COMPOSE_ENV := $(ENV_FILE)
else
  COMPOSE_ENV :=
endif

.PHONY: up down build logs ps restart clean

up:
	docker compose -f $(COMPOSE_FILE) $(COMPOSE_ENV) up -d --build

down:
	docker compose -f $(COMPOSE_FILE) down

build:
	docker compose -f $(COMPOSE_FILE) $(COMPOSE_ENV) build

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

ps:
	docker compose -f $(COMPOSE_FILE) ps

restart: down up

clean: down
	docker compose -f $(COMPOSE_FILE) down -v
