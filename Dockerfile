FROM ubuntu:latest

RUN apt update && apt install -y curl php-cli php-mbstring git unzip composer redis-server mariadb-server \
    && mkdir -p /var/www/pterodactyl \
    && curl -Lo /var/www/pterodactyl/panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz \
    && tar -xvzf /var/www/pterodactyl/panel.tar.gz -C /var/www/pterodactyl && rm /var/www/pterodactyl/panel.tar.gz

WORKDIR /var/www/pterodactyl

RUN composer install --no-dev --optimize-autoloader

CMD ["/bin/bash"]
