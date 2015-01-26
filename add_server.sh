#!/bin/bash

ID=$(docker run -d --link rdb:rdb -v `pwd`:/home/app pastie)
echo $ID >> ids
HOST=$(docker inspect -f '{{.NetworkSettings.IPAddress}}' $ID)
echo $HOST >> jinja/hosts
(cd jinja ; docker run -it -v `pwd`:/data --volumes-from nginx attero/jinja python update_nginx_conf.py )
docker restart nginx
