FROM debian:bookworm-slim

# Default is only used for local/manual `docker build .` — CI always overrides this via
# --build-arg so new MicroPython releases never require a Dockerfile edit.
ARG MICROPY_VERSION=v1.29.0

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
RUN git clone --depth 1 --branch ${MICROPY_VERSION} https://github.com/micropython/micropython.git
RUN make -C micropython/mpy-cross
RUN make -C micropython/ports/unix VARIANT=coverage submodules
RUN make -C micropython/ports/unix VARIANT=coverage
RUN make -C micropython/ports/unix VARIANT=coverage install
RUN apt-get purge --auto-remove -y build-essential git pkg-config python3
RUN rm -rf micropython

ENTRYPOINT ["/usr/local/bin/micropython"]
