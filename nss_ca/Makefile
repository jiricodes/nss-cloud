##
## SETTINGS ####################################################################
##

### General

PRIV_KEYS_DIR=private
### CA

CA_CFG=nss-ca.cnf
CA_CERT=cacert.pem
CA_KEY=$(PRIV_KEYS_DIR)/cakey.pem

SERVER_CFG=nss-server.cnf

##
## RULES #######################################################################
##
.PHONY: all build build-ca build-server sign-server clean fclean re

all: build-ca build-server sign-server

build: build-ca build-server

prereqs:
	@mkdir -p private/

build-ca: prereqs
	@echo "Building NSS-CA"
	@openssl req -x509 -config $(CA_CFG) -newkey rsa:4096 -sha256 -out $(CA_CERT) -outform PEM -batch
	@mv privkey.pem $(CA_KEY)

show-ca:
	openssl x509 -in $(CA_CERT) -text -noout

build-server:

sign-server:

clean:

fclean:
	@rm -r private/
	@rm -f *.pem

re: