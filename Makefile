CONTAINER_USERID = $(shell id -u tomcat8)

all:
	docker build --build-arg container_userid=$(CONTAINER_USERID) -t ecad:v1 .
