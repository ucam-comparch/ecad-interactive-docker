CONTAINER_USERID = 1000
VERSION = v4

all:	build

build:
	docker build --build-arg ubuntu_version=18.04 --build-arg container_userid=$(CONTAINER_USERID) -t ecad-riscv:$(VERSION) .

vm-tools:
	docker build --build-arg ubuntu_version=16.04 --build-arg container_userid=$(CONTAINER_USERID) -t ecad-mcs:$(VERSION) .

push:
	docker tag ecad-riscv:$(VERSION) ucamcstecad/ecad-riscv:latest
	docker push ucamcstecad/ecad-riscv:latest

run:
	docker run -it ecad-riscv:$(VERSION)

