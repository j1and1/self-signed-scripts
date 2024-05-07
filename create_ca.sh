#!/usr/bin/bash

echo "Installing dependencies..."
sudo apt update && sudo apt install easy-rsa -y

echo "Prepearing dir..."
mkdir ~/easy-rsa
ln -s /usr/share/easy-rsa/* ~/easy-rsa/
chmod 700 ~/easy-rsa

cd ~/easy-rsa
./easyrsa init-pki

echo "Edit VARS configuration. See README.md"
read -p "Press enter after you have edited the configuration file."

./easyrsa build-ca nopass
echo "CA cert can be located here: ~/easy-rsa/pki/ca.crt"