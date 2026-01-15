#!/usr/bin/env bash
set -euo pipefail

if [ -z "${1:-}" ]; then
    echo "Devi specificare il nome del modulo" >&2
    exit 1
fi

SERVICE_NAME=${SERVICE_NAME:-prestashop}
MODULE="$1"
MODULE_PATH="/var/www/html/modules/$MODULE"

echo "Aggiornamento composer del modulo $MODULE"

docker compose exec -T "$SERVICE_NAME" sh -lc "test -d '$MODULE_PATH'" || {
    echo "Modulo non trovato nel container: $MODULE_PATH" >&2
    exit 1
}

docker compose exec -T "$SERVICE_NAME" sh -lc "test -f '$MODULE_PATH/composer.json'" || {
    echo "composer.json non trovato in: $MODULE_PATH" >&2
    exit 1
}

docker compose exec -T "$SERVICE_NAME" sh -lc "rm -rf '$MODULE_PATH/vendor'"

docker compose exec -T -w "$MODULE_PATH" "$SERVICE_NAME" composer install
docker compose exec -T -w "$MODULE_PATH" "$SERVICE_NAME" composer update
docker compose exec -T -w "$MODULE_PATH" "$SERVICE_NAME" composer dump-autoload

echo "Aggiornamento effettuato"
