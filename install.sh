#!/usr/bin/env bash
set -euo pipefail

SERVICE_NAME=${SERVICE_NAME:-prestashop}

docker compose down

sudo rm -rf ./prestashop
sudo rm -rf ./db_data

docker compose build --no-cache
docker compose up -d

echo "Attendere l'installazione di Prestashop 8.2..."

sleep 60

sudo chown -R 33:33 ./prestashop
sudo chmod -R 775 ./prestashop

cat > ./prestashop/info.php <<'PHP'
<?php
phpinfo();
PHP

echo "Prestashop installato sul container $SERVICE_NAME"