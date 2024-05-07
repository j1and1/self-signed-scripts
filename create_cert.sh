#!/usr/bin/bash
echo "Creating directory"
mkdir ~/cert
cd ~/cert

echo "Creating request"
# create CSR
openssl genrsa -out "$1.key"
openssl req -new -key "$1.key" -out "$1.req"

echo "Signing"
cd ~/easy-rsa
./easyrsa import-req ~/cert/$1.req $1
./easyrsa sign-req server "$1"

echo "Copying the files back"
cp ~/easy-rsa/pki/issued/$1.crt ~/cert/$1.crt
