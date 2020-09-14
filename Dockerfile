FROM ubuntu:18.04
ARG container_userid

RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo vim nano joe emacs curl wget htop gnupg patch screen tmux rsync time strace openssh-client less \ 
        git ca-certificates \
        autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev \
        device-tree-compiler && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd ecad
RUN useradd --shell /bin/bash -u ${container_userid} -o -c "" -m ecad -g ecad

ENV buildroot=/home/ecad/build
ENV RISCV=/ux/clteach/ecad/riscv32/
RUN mkdir -p ${RISCV}/bin
RUN chown -R ecad ${RISCV}
USER ecad
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
    ../configure --prefix=${RISCV} --enable-commitlog && \
    make && \
    make install
RUN \
    cd /home/ecad && \
    rm -rf ${buildroot}
WORKDIR /home/ecad

USER root
RUN echo "#!/bin/bash\n\
export RISCV=${RISCV}\n\
export PATH=$RISCV/bin:$PATH\n" > /ux/clteach/ecad/setup.bash 

USER ecad
CMD ["/bin/bash", "-l"]

