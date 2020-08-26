CONTAINER_USERID = $(shell id -u jf613)

all:
	docker build --build-arg container_userid=$(CONTAINER_USERID) -t ecad:v1 .
