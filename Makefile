CONTAINER_USERID = 1000
VERSION = v2

all:	build

build:
	docker build --build-arg container_userid=$(CONTAINER_USERID) -t ecad-riscv:$(VERSION) .

run:
	docker run -it ecad-riscv:$(VERSION)
	