##
## SETTINGS ####################################################################
##

CA_CFG=nss-ca.cnf
SERVER_CFG=nss-server.cnf

##
## RULES #######################################################################
##
.PHONY: all build build-ca build-server sign-server clean fclean re

all: build-ca build-server sign-server

build: build-ca build-server

build-ca:
	@echo "Building NSS-CA"
	openssl req -x509 -config $(CA_CFG) -outform PEM

build-server:

sign-server:

clean:

fclean:

re: