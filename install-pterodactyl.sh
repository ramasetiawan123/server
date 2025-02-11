#!/bin/bash

set -e  # Stop jika terjadi error

# Update sistem dan install dependensi
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl php-cli php-mbstring git unzip composer redis-server

# Install MariaDB
sudo apt install -y mariadb-server
sudo systemctl enable --now mariadb

# Konfigurasi database
sudo mysql -e "CREATE DATABASE pterodactyl;"
sudo mysql -e "CREATE USER 'pterodactyl'@'localhost' IDENTIFIED BY 'strongpassword';"
sudo mysql -e "GRANT ALL PRIVILEGES ON pterodactyl.* TO 'pterodactyl'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Install Panel Pterodactyl
mkdir -p /var/www/pterodactyl
cd /var/www/pterodactyl
curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
tar -xvzf panel.tar.gz && rm panel.tar.gz

# Install dependensi Laravel
cp .env.example .env
composer install --no-dev --optimize-autoloader
php artisan key:generate
php artisan migrate --seed --force
php artisan storage:link
chown -R www-data:www-data /var/www/pterodactyl
chmod -R 755 /var/www/pterodactyl

# Install Wings (Daemon)
curl -Lo /usr/local/bin/wings https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64
chmod +x /usr/local/bin/wings

echo "Pterodactyl Panel & Wings telah diinstal. Akses panel melalui port 80."
