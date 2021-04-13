
FROM debian:buster

LABEL	maintainer="wluong@student.42.fr"

#UPDATING

RUN 	apt-get update
RUN 	apt-get upgrade -y
RUN 	apt-get install openssl -y
RUN	apt-get install wget -y

#NGINX

RUN 	apt-get install nginx -y
COPY	./srcs/default /etc/nginx/sites-available/

#MYSQL

RUN 	apt-get install -y mariadb-server

#PHPMYADMIN

RUN	apt-get install -y \
	php7.3-fpm \
	php-mysql \
	php-mbstring \
	php-pdo

RUN 	wget	https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz
RUN	tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz
RUN	mv phpMyAdmin-5.0.2-all-languages phpmyadmin
RUN	mv phpmyadmin /var/www/html/
RUN	rm phpMyAdmin-5.0.2-all-languages.tar.gz
COPY	./srcs/config.inc.php /var/www/html/phpmyadmin


#WORDPRESS

RUN	wget	https://wordpress.org/latest.tar.gz
RUN	tar -xvf latest.tar.gz
RUN 	mv wordpress/ /var/www/html
RUN	rm latest.tar.gz
COPY	./srcs/wp-config.php /var/www/html/wordpress

#CHMOD

RUN	chown -R www-data:www-data /var/www/*
RUN	chmod -R 755 /var/www/*

#START

COPY	./srcs/run.sh ./
CMD	bash run.sh

EXPOSE 	80 443
