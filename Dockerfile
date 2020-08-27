FROM ubuntu:18.04
ARG container_userid

RUN apt-get update && \
    apt-get install -y --no-install-recommends git ca-certificates && \
    apt-get install -y --no-install-recommends autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev && \
    apt-get install -y --no-install-recommends device-tree-compiler && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd user
RUN useradd --shell /bin/bash -u ${container_userid} -o -c "" -m user -g user

USER user
ENV buildroot=/home/user/build
ENV RISCV=/home/user/riscv
RUN mkdir -p ${buildroot}

RUN git clone --recursive https://github.com/riscv/riscv-gnu-toolchain.git ${buildroot}/riscv-gnu-toolchain
WORKDIR ${buildroot}/riscv-gnu-toolchain
RUN ./configure --prefix=${RISCV} --with-arch=rv32i
RUN make

ENV PATH="${RISCV}/bin:${PATH}"

RUN git clone https://github.com/riscv/riscv-isa-sim.git ${buildroot}/riscv-isa-sim
RUN mkdir ${buildroot}/riscv-isa-sim/build
WORKDIR ${buildroot}/riscv-isa-sim/build
RUN ../configure --prefix=${RISCV}
RUN make
RUN make install

WORKDIR /home/user
RUN rm -rf ${buildroot}

USER root
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN mkdir /pottery-binaries
COPY bin/* /pottery-binaries/
RUN chmod 755 /usr/local/bin/entrypoint.sh /pottery-binaries/*

USER user
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
