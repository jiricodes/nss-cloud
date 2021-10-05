# NSS CA
This folder contains all config files, generated certificates and keys for testing purposes.

# Process
First we setup our own CA, then we setup Server key and certs and then we use CA to sing the Server certificate.

# Usage
## Basic
To generate CA cert and key, Server cert and key and signed server cert.
```
make
```

Without signing
```
make build
```

Only signing. Can be used multiple times, creates a series in `newcerts/`
```
make sign-server
```

Other tools
```
#cleans everything
make fclean

#reruns the whole thing -> make fclean && make
make re
```

## Advanced
If you want to customize the passphrase for `cakey.pem` (recommended). Change `config/nss-ca.cnf` line/s `input_password` / `output_password` in `[ req ]` category. And then supply the same to make command with `PASS=your_passphrase`.

e.g.
```
make PASS=testpass
```


## Use
TBC

# Files

## config/nss-ca.cnf
Configuration file for the CA setup. 

Built based on OpenSSL's [template](https://github.com/openssl/openssl/blob/master/apps/openssl.cnf)

Exposed password - should be omitted or commented out for external deployment, it's here for testing purposes. Optionally one can use `-nodes` option with `openssl req -x509` command to omit the password upon generation.

crl_ext should be reviewed.

## config/nss-server.cnf
Config file for Server setup.

TBC

## data/ (generated)
Folder containing openssl database to track signed certs

## certs/ (generated)
Folder containing CA and Server cert

## newcerts/ (generated)
Folder containing final signed certificates

## private/ (generated)
Folder containing CA and Server private keys
