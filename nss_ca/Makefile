##
## SETTINGS ####################################################################
##

### General

PRIV_KEYS_DIR=private
CFG_DIR=config
CERTS_DIR=certs
SIGNED_DIR=newcerts
DATA_DIR=data

### DATA files

IDX=$(DATA_DIR)/index.txt
SER=$(DATA_DIR)/serial.txt

### CA

CA_CFG=$(CFG_DIR)/nss-ca.cnf
CA_CERT=$(CERTS_DIR)/cacert.pem
CA_KEY=$(PRIV_KEYS_DIR)/cakey.pem

### Server

SERVER_CFG=$(CFG_DIR)/nss-server.cnf
SERVER_CERT=$(CERTS_DIR)/servercert.csr
SERVER_KEY=$(PRIV_KEYS_DIR)/serverkey.pem
SERVER_SIGNED=$(CERTS_DIR)/servercert_signed.pem

##
## RULES #######################################################################
##
.PHONY: all build build-ca build-server sign-server clean fclean re

all: build-ca build-server sign-server

build: build-ca build-server

prereqs-dirs:
	@mkdir -p $(PRIV_KEYS_DIR)
	@mkdir -p $(CERTS_DIR)
	@mkdir -p $(SIGNED_DIR)
	@mkdir -p $(DATA_DIR)

prereqs: prereqs-dirs
	@touch $(IDX)
	@echo "01" > $(SER)

build-ca: prereqs
	@echo "Building NSS-CA"
	@openssl req -x509 -config $(CA_CFG) -newkey rsa:4096 -sha256 -out $(CA_CERT) -outform PEM -batch
	@mv privkey.pem $(CA_KEY)

show-ca:
	openssl x509 -in $(CA_CERT) -text -noout

purpose-ca:
	openssl x509 -purpose -in $(CA_CERT) -inform PEM

build-server: prereqs
	openssl req -config $(SERVER_CFG) -newkey rsa:2048 -sha256 -out $(SERVER_CERT) -outform PEM -batch

show-server:
	openssl req -text -noout -verify -in $(SERVER_CERT)

sign-server: prereqs-dirs
	yes | openssl ca -config $(CA_CFG) -passin pass:secret -policy policy_match -extensions v3_ca -out $(SERVER_SIGNED) -infiles $(SERVER_CERT)

show-signed:
	openssl x509 -in $(SERVER_SIGNED) -text -noout

clean:

fclean: clean
	rm -r $(PRIV_KEYS_DIR) $(CERTS_DIR) $(SIGNED_DIR) $(DATA_DIR)
	rm -f *.pem *.csr

re: fclean all