#!/bin/sh
docker run -p 389:389 -p 636:636 --name ldap --detach --memory=384m --memory-reservation=256m --memory-swap=768m --cpus=.5 --restart always osixia/openldap:1.5.0
