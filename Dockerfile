FROM docker.io/centos:6.8
RUN yum install -y wget curl vim git
COPY src /var/www/html
EXPOSE 80
