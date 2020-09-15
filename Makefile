CONTAINER_USERID = 1000
VERSION = v2

all:	build

build:
	docker build --build-arg ubuntu_version=18.04 --build-arg container_userid=$(CONTAINER_USERID) -t ecad-riscv:$(VERSION) .

vm-tools:
	docker build --build-arg ubuntu_version=16.04 --build-arg container_userid=$(CONTAINER_USERID) -t ecad-mcs:$(VERSION) .


run:
	docker run -it ecad-riscv:$(VERSION)

