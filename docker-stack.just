# Docker stack recipes. Import this from the root justfile.
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
