NAME   = pastie
 
all    : build run
 
run : .rethink build stop
	docker run -d --name rdb -v /var/docker/rethinkdb:/data rethinkdb
	@sleep 1
	docker run -it --link rdb:rdb -p 9292:9292 --name $(NAME)_c $(NAME)

build  : .built

.built : .
	docker build -t $(NAME) .
	@docker inspect -f '{{.Id}}' $(NAME) > .built

.rethink :
	docker pull rethinkdb 
	@touch .rethink

stop  :
	@docker stop rdb > /dev/null && docker rm rdb > /dev/null
	@docker stop $(NAME)_c > /dev/null && docker rm $(NAME)_c > /dev/null

clean :
	@rm .built
	@rm .rethink

re     : clean all
 
.PHONY : all build clean re run_rethink
