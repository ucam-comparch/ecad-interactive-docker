FROM ubuntu:18.04
ARG container_userid

RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo vim nano joe emacs curl wget htop gnupg patch screen tmux rsync time strace openssh-client \ 
        git ca-certificates \
        autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev \
        device-tree-compiler && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd user
RUN useradd --shell /bin/bash -u ${container_userid} -o -c "" -m user -g user

ENV buildroot=/home/user/build
ENV RISCV=/ux/clteach/ecad/riscv32/
RUN mkdir -p ${RISCV}/bin
RUN chown -R user ${RISCV}
USER user
ENV PATH="${PATH}:${RISCV}/bin"
RUN mkdir -p ${buildroot} && \
    git clone --recursive https://github.com/riscv/riscv-gnu-toolchain.git ${buildroot}/riscv-gnu-toolchain
RUN \
    cd ${buildroot}/riscv-gnu-toolchain && \
    ./configure --prefix=${RISCV} --with-arch=rv32i && \
    make
RUN \
    git clone https://github.com/riscv/riscv-isa-sim.git ${buildroot}/riscv-isa-sim
RUN \
    mkdir ${buildroot}/riscv-isa-sim/build && \
    cd ${buildroot}/riscv-isa-sim/build && \
    ../configure --prefix=${RISCV} && \
    make && \
    make install
RUN \
    cd /home/user && \
    rm -rf ${buildroot}
WORKDIR /home/user

RUN echo -e '#!/bin/bash\n\
export RISCV=${RISCV}\
export PATH=$RISCV/bin:$PATH\
>> /ux/clteach/ecad/setup.bash 

USER user
ENTRYPOINT ["/bin/bash"]
