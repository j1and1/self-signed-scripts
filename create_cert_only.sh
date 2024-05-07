#!/usr/bin/bash

mkdir ~/certs/
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ~/certs/$1.key -out ~/certs/$1.crt
openssl dhparam -out ~/certs/$1.pem 2048