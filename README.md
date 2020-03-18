# Docker: CMS
Dockerfile for CMS (Contest Management System).

docker-compose file includes:
 - CMS
 - RWS
 - Traefik support
 - Postgres

## Setup:
1. clone the repo
2. create `.env` file from `.env.example`
3. create `cms.conf` from `config/cms.conf.sample`
4. create `cms.ranking.conf` from `config/cms.ranking.conf.sample`
5. create `isolate.conf` from `config/isolate.conf.sample`
6. run `randomize-secret.sh` in `config` dir

## Network settings:
The stack is divided into two networks, backend and frontend.

the idea behind splitting the stack into two networks
is to block the access of the reverse proxy to the backend containers.

both networks are unique and will be named with stack-name_network-name such as:

- docker-cms_backend
- docker-cms_frontend

after running docker-compose up you need to connect your reverse proxy to your new frontend network:
 you can do that manually using:
 
```
 docker network connect docker-cms_frontend PROXY_CONTAINER_NAME
 ```

if you are using my Traefik setup there is a `connect.sh` script included that will connect all your frontend networks to your Traefik container.

Author: [RaveMaker][RaveMaker].

[RaveMaker]: http://ravemaker.net