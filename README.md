# Self signed certificate creation scripts

This repo contains scripts that are based on the following DigitalOcean articles [here](https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-a-certificate-authority-ca-on-ubuntu-20-04) and [here](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04). 

These scripts are for generating a CA or a self signed cert that can be installed on phone so you can access self hosted services from android phone.

## Scripts and their purposes

1. `create_ca.sh` - Installs easy-RSA and creates a CA
2. `create_cert.sh` - Creates a certificate signed by CA
3. `create_cert_only.sh` - Creates a self signed cert without using a CA

## Usage

### Creating a self signed cert only

To generate a self signed cert just run `./create_cert_only.sh <cert_name>` from linux terminal and after entering the information openssl asks you you will have a cert with `<cert_name>` as a filename inside `~/certs/` folder

### Create a cert authority

To create a CA if you want to use multiple services with the same trusted source, you should run `create_ca.sh` from a linux terminal. This script will install the needed dependencies and ask you to create or edit the `~/easy-rsa/vars` the file contents should look like the following example

```
set_var EASYRSA_REQ_COUNTRY    "US"
set_var EASYRSA_REQ_PROVINCE   "NewYork"
set_var EASYRSA_REQ_CITY       "New York City"
set_var EASYRSA_REQ_ORG        "CompanyName"
set_var EASYRSA_REQ_EMAIL      "admin@example.com"
set_var EASYRSA_REQ_OU         "Community"
set_var EASYRSA_ALGO           "ec"
set_var EASYRSA_DIGEST         "sha512"
```

when you have modified the vars file just save the file and press enter inside the terminal you ran the script from. If everything went well then you have a CA cert file inside `~/easy-rsa/pki/ca.crt` folder.

### Create a CA signed cert

To create a CA signed cert you will need to run `./create_cert.sh <cert_name>` enter the asked information and if everything went well then you can locate the newly created certificates inside `~/certs/` folder.

## Reverse proxy example

To use the self signed certs with a reverse proxy you will need to create a folder in this example we will call the folder `ssl`. Within the ssl folder we can create a file called `proxy_ssl.conf`.. inside this `ssl/proxy_ssl.conf` file we will put the following contents

```
server {
  listen 443 ssl;
  ssl_certificate /etc/nginx/conf.d/<cert_file_name>.crt;
  ssl_certificate_key /etc/nginx/conf.d/<cert_key_file_name>.key;
  location / {
     proxy_pass http://<target_server_ip>:<target_server_port>;
     proxy_redirect http://<current_server_ip> https://<current_server_ip>/;
  }
}
```

after you have created this file you will need to copy the self signed certs to the same `ssl` folder. 

After the file is created and certificates have been copied you will now need to create a `docker-compose.yml` file within the root directory. The docker-compose.yml file should contain the following contents.

```
version: "3"
services:

  # other container can be placed here

  proxy:
    image: nginx
    container_name: proxy
    restart: always
  #  depends_on:
  #    - other container name goes here
    volumes:
      - ./ssl:/etc/nginx/conf.d
    ports:
      - 80:80
      - 443:443

```

after the compose file has been created and saved the folder structure should look something like this

```
<root>
| - docker-compose.yml
| - ssl
  | - proxy_ssl.conf
  | - cert.crt
  | - cert.key
```

once the folder looks like the folder structure above and the files have been created you just simply need to run `docker-compose up -d` and the docker should get the nginx image and start the proxy container.