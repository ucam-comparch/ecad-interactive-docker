CONTAINER_USERID = 1000
VERSION = v2

all:
	docker build --build-arg container_userid=$(CONTAINER_USERID) -t ecad-riscv:$(VERSION) .
