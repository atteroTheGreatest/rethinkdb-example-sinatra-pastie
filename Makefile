NAME   = pastie
 
run :	build stop nginx rethink addserver

build  : .built .rethink .nginx .jinja

.built : Dockerfile Gemfile Gemfile.lock
	docker build -t $(NAME) .
	docker inspect -f '{{.Id}}' $(NAME) > .built

rethink: .rethink
	docker run -d --name rdb -p 8080:8080 --restart=always -v /var/docker/rethinkdb:/data rethinkdb

.rethink :
	docker pull rethinkdb 
	touch .rethink

nginx: .nginx
	docker run -d -p 80:80 --name=nginx --restart=always attero/nginx

.nginx:
	(cd nginx; docker build -t attero/nginx .)
	touch .nginx

.jinja:
	(cd jinja; docker build -t attero/jinja .)
	touch .jinja

stop  :
	docker rm -f nginx 2> /dev/null || true
	docker rm -f rdb 2> /dev/null || true
	docker rm -f `cat ids` 2> /dev/null || true
	rm ids || true
	rm jinja/hosts || true

addserver:
	./add_server.sh

clean : stop
	rm .built
	rm .rethink

re     : clean all
 
.PHONY : clean re run nginx rethink
