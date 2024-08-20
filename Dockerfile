FROM debian:bookworm-slim

RUN apt update && \
    apt install -y gcc-multilib \
        g++-multilib \
        libffi-dev \
        python3 \
        python3-pip \
        python3-setuptools \
        python3-pyelftools \
        git \
        autoconf \
        libtool \
        pkg-config\
        libsqlite3-dev

RUN rm -rf /var/lib/apt/lists/*
RUN git clone --depth 1 --branch v1.23.0 https://github.com/micropython/micropython.git
RUN make -C micropython/mpy-cross
RUN make -C micropython/ports/unix submodules
RUN make -C micropython/ports/unix
RUN make -C micropython/ports/unix install
RUN apt-get purge --auto-remove -y build-essential git pkg-config python3
RUN rm -rf micropython

CMD ["/usr/local/bin/micropython"]
