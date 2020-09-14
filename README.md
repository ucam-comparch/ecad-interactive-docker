Docker image for interactive use in ECAD labs

To build first time:

	docker build -t ecad-riscv .

To run a shell inside Docker image, mounting your current directory inside

	docker run -v $(pwd):/home/ecad/work -it ecad-riscv
	cd work


