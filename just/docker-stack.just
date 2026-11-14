# Docker stack recipes. Lives at just/docker-stack.just.
# The root justfile loads it with: import 'just/docker-stack.just'
# Operator recipes. Run them only when Axel has asked for that stack change.

up:
    docker compose up -d

down:
    docker compose down

restart:
    docker compose restart

logs:
    docker compose logs -f --tail=200

ps:
    docker compose ps

pull:
    docker compose pull

config:
    docker compose config
