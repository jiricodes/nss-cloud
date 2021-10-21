#!/bin/sh
docker run -p 389:389 -p 636:636 --name ldap --detach --memory=384m --memory-reservation=256m --memory-swap=768m --cpus=.5 --restart always \
-v /home/cloud-user/certs:/container/service/slapd/assets/certs \
-e LDAP_TLS_CA_CRT_FILENAME=ca.crt \
-e LDAP_TLS_CRT_FILENAME=cert1.pem \
-e LDAP_TLS_KEY_FILENAME=ldap.key \
-e ALLOW_EMPTY_PASSWORD=yes \
-e LDAP_TLS_VERIFY_CLIENT=try \
osixia/openldap:1.5.0 --loglevel=trace
