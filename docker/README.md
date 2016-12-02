This Docker configuration is intended for _development_ of Docker. It is not intended to be useful for production.

## Usage

First run `./docker/build.sh` from the top level source directory.

Your node needs to be in swarm mode. If it is not then `docker swarm init`.

You will need to `docker volume create` the following volumes. These can be plain volumes or they could be e.g. NFS backend volumes etc:

- `mythtv-db`: Used for `/var/lib/mysql` in the DB container.
- `mythtv-music`: MythMusic content.
- `mythtv-recordings`: Recodings content.

A simple `docker volume create «name»` or you may like to use e.g. a readonly NFS mount of your existing music foler

Then `docker stack deploy -c docker/docker-compose.yml «name»`

xvncviewer :0 # connect to frontend
xvncviewer :1 # connect to backend, if MYTHTV_SETUP is set in the env
