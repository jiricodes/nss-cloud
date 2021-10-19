# NSS cloud configuration files and scripts

## Nextcloud
The configuration file [`nextcloud.conf`](nextcloud.conf) is stripped classified information. Please refer to [Nextcloud's documentation](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/index.html) for detailed information.

## Postgresql
The configuration can be found in [pg_hba.conf](pg_hba.conf) and docker start script in [postgresql.sh](postgresql.sh).

## LDAP
[ldap.sh](ldap.sh) can be used to run the LDAP docker.

## License
LDAP's Apache License, Version 2.0 [allows it to be added as a module](https://www.apache.org/licenses/GPL-compatibility.html) under Nextcloud's license [GNU AGPLv3](https://github.com/nextcloud/server/blob/master/COPYING). Similary [PostgreSQL's liberal licence](Postgresql) is compatible with GNU AGPLv3. However in both cases the licenses are not compatible in the opposite direction (GNU AGPLv3 cannot be a module of MIT or Apache License v2 based projects) and therefore this project needs to be licensed under the same GNU AGPLv3, as stated in the [LICENSE](../LICENSE) file.