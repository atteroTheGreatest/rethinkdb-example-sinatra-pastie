NAME   = pastie

# run target, images have to be available first and containers have to be stopped
# before running
run : .rethink build stop
	docker run -d --name rdb -v /var/docker/rethinkdb:/data rethinkdb
	@sleep 1
	docker run -it --link rdb:rdb -p 9292:9292 --name $(NAME)_c -v `pwd`:/home/app $(NAME)

build  : .built

.built : Dockerfile Gemfile Gemfile.lock
	docker build -t $(NAME) .
	docker inspect -f '{{.Id}}' $(NAME) > .built

# make sure that we have the newest rethinkdb image
.rethink :
	docker pull rethinkdb 
	@touch .rethink

# stop and remove containers
stop  :
	@(docker stop rdb > /dev/null && docker rm rdb > /dev/null) || true
	@(docker stop $(NAME)_c > /dev/null && docker rm $(NAME)_c > /dev/null) || true


# enforce rebuilding and pulling image the next time
clean : stop
	rm .built
	rm .rethink

# clean and run all again
re     : clean run

# list of targets without artifacts
.PHONY : run build clean re
