FROM php:7.3-apache

MAINTAINER main@jdkhome.com

WORKDIR /usr/local/bin/
EXPOSE 80
ENV CLOUDREVE_TOKEN 123456
ENV ARIA2_TOKEN 123456

RUN apt-get update 
RUN apt-get install -y libfreetype6-dev
RUN apt-get install -y libfreetype6-dev 
RUN apt-get install -y libjpeg62-turbo-dev 
RUN apt-get install -y libpng-dev 
RUN apt-get install -y libcurl4-openssl-dev
RUN apt-get install -y aria2
RUN apt-get install -y sudo

RUN docker-php-ext-install -j$(nproc) pdo
RUN docker-php-ext-install -j$(nproc) pdo_mysql
RUN docker-php-ext-install -j$(nproc) mysqli
RUN docker-php-ext-install -j$(nproc) gd 
RUN docker-php-ext-install -j$(nproc) fileinfo 
RUN docker-php-ext-install -j$(nproc) curl

# 开启 rewrite
RUN a2enmod rewrite

# php配置文件
COPY php.ini /usr/local/etc/php/

# 应用主程序
COPY cloudreve/ /var/www/html/

# taskqueue (OneDrive支持)
COPY taskqueue_1.1_linux_amd64/ /usr/local/bin/
RUN chmod +x /usr/local/bin/taskqueue
COPY taskqueue-conf.tpl /usr/local/bin/taskqueue-conf.tpl
RUN chmod 777 /usr/local/bin/taskqueue-conf.tpl

# aria2 (离线下载支持)
RUN mkdir /etc/aria2
RUN touch /etc/aria2/aria2.session
COPY aria2-conf.tpl /etc/aria2/aria2-conf.tpl
RUN chmod -R 777 /etc/aria2
# aria2 下载目录
RUN mkdir /var/www/html/temp
RUN chmod -R 777 /var/www/html/temp

# 应用目录权限
RUN chmod -R 777 /var/www/html/runtime
RUN chmod -R 777 /var/www/html/public
RUN chmod -R 777 /var/www/html/application

# 启动脚本
COPY run.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run.sh

ENTRYPOINT ["/usr/local/bin/run.sh"]
# COPY index.php /var/www/html/
