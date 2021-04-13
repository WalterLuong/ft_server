#!/bin/bash

echo "\033[1;32mFT_SERVEUR WLUONG\033[0;m"

#CHMOD START.SH
chmod 775 /run.sh

#SSL KEY AND CERTIFICATE
openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=FR/ST=75/L=Paris/O=42Paris/OU=wluong/CN=localhost" -keyout localhost.dev.key -out localhost.dev.crt
mv localhost.dev.crt etc/ssl/certs/
mv localhost.dev.key etc/ssl/private/
chmod 600 /etc/ssl/certs/localhost.dev.crt
chmod 600 /etc/ssl/private/localhost.dev.key

#AUTOINDEX

if [ "$AUTOINDEX" = "off" ]; then
	sed -i "s/autoindex on/autoindex off/g" /etc/nginx/sites-available/default;
#else if [ "$AUTOINDEX" = "on" ]; then
else
	sed -i "s/autoindex off/autoindex on/g" /etc/nginx/sites-available/default;
fi

#START SERVICES
service nginx start
service mysql start
service php7.3-fpm start
service php7.3-fpm status

#DB CREATION FOR WORDPRESS
echo "CREATE DATABASE wordpress;"| mysql -u root --skip-password
echo "CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'admin';"| mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'admin'@'localhost' WITH GRANT OPTION;"| mysql -u root --skip-password
echo "FLUSH PRIVILEGES;"| mysql -u root --skip-password

bash

sleep infinity 
#remplace le -it

#docker build -t name .
#docker run -p 80:80 -p 443:443
#autoindex : docker run --env AUTOINDEX=off -p 80:80 -p 443:443