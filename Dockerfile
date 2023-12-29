FROM debian:bookworm-slim

RUN apt update && \
    apt install -y gcc-multilib g++-multilib libffi-dev python3 python3-pip python3-setuptools python3-pyelftools git autoconf libtool pkg-config && \
    rm -rf /var/lib/apt/lists/* && \
    git clone --depth 1 --branch v1.22.0 https://github.com/micropython/micropython.git && \
    cd micropython && \
    cd mpy-cross && \
    make && \
    cd .. && \
    cd ports/unix && \
    make submodules deplibs && \
    make && \
    make install && \
    apt-get purge --auto-remove -y build-essential libffi-dev git pkg-config python3 && \
    cd ../../.. && \
    rm -rf micropython && \
    mkdir code

WORKDIR code

CMD ["/usr/local/bin/micropython"]
