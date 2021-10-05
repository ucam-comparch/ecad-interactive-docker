CONTAINER_USERID = 1000
VERSION = 20210930

all:	build

build:
	docker build --build-arg ubuntu_version=20.04 --build-arg container_userid=$(CONTAINER_USERID) -t ecad-riscv:$(VERSION) .

vm-tools:
	docker build --build-arg ubuntu_version=20.04 --build-arg container_userid=$(CONTAINER_USERID) -t ecad-mcs:$(VERSION) .

push:
	docker tag ecad-riscv:$(VERSION)-$(ARCH) ucamcstecad/ecad-riscv:$(VERSION)-$(ARCH)
	docker push ucamcstecad/ecad-riscv:$(VERSION)-$(ARCH)

manifest:
	docker manifest create ucamcstecad/ecad-riscv:$(VERSION) ucamcstecad/ecad-riscv:$(VERSION)-arm64 ucamcstecad/ecad-riscv:$(VERSION)-amd64
	docker manifest push --purge ucamcstecad/ecad-riscv:$(VERSION)
	docker manifest create ucamcstecad/ecad-riscv:latest ucamcstecad/ecad-riscv:$(VERSION)-arm64 ucamcstecad/ecad-riscv:$(VERSION)-amd64
	docker manifest push --purge ucamcstecad/ecad-riscv:latest

run:
	docker run -it ecad-riscv:$(VERSION)
