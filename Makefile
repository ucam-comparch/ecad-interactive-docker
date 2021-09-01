CONTAINER_USERID = 1000
VERSION = v6

all:	build

build:
	docker build --build-arg ubuntu_version=20.04 --build-arg container_userid=$(CONTAINER_USERID) -t ecad-riscv:$(VERSION)_focal .

vm-tools:
	docker build --build-arg ubuntu_version=20.04 --build-arg container_userid=$(CONTAINER_USERID) -t ecad-mcs:$(VERSION)_focal .

push:
	docker tag ecad-riscv:$(VERSION) ucamcstecad/ecad-riscv:latest
	docker push ucamcstecad/ecad-riscv:latest

run:
	docker run -it ecad-riscv:$(VERSION)

