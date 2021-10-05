# NSS CA
This folder contains all config files, generated certificates and keys for testing purposes.

# Process
First we setup our own CA, then we setup Server key and certs and then we use CA to sing the Server certificate.

# Usage
## Generation
TBC

## Use
TBC

# Files
## nss-ca.cnf
Configuration file for the CA setup. 

Built based on OpenSSL's [template](https://github.com/openssl/openssl/blob/master/apps/openssl.cnf)

Exposed password - should be omitted or commented out for external deployment, it's here for testing purposes. Optionally one can use `-nodes` option with `openssl req -x509` command to omit the password upon generation.

crl_ext should be reviewed.

## nss-server.cnf
