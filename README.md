# docker-micropython-linux
Docker image that comes loaded with the unix (linux in this case) port of micropython.

#### Why use this? Simple:

* Running automated tests against libraries intended for micropython (you *can* use python3, but there are edge cases).
* Experimenting with micropython without any complexity of building yourself or overhead of buying a board first.
* There wasn't an existing and well-maintained image.

The image is based off the official Debian-slim (bookworm) because it's fairly slim (not as slim as alpine, but that can be a headache to build), and is built using the `coverage` variant of the unix port — this enables almost every optional MicroPython feature (e.g. `sys.settrace`, split heap), since the unix port is primarily used for testing rather than as a lean runtime.

#### Getting Started

Providing you have access to Docker, you can run the latest version quite easily by:

    $ docker run -it micropython/unix
    MicroPython v1.29.0 on 2026-08-27; linux [GCC 12.2.0] version
    Use Ctrl-D to exit, Ctrl-E for paste mode
    >>> ^C

Tags are available on the [Docker Hub listing](https://hub.docker.com/r/micropython/unix/tags) — `latest` always tracks the newest MicroPython release, and each release is also available pinned by version, e.g. `micropython/unix:v1.29.0`.

You can also run a one-off script directly, since the image's entrypoint is the `micropython` binary itself:

    $ docker run --rm micropython/unix -c "print('hello from micropython')"
    hello from micropython

To install a package from micropython-lib, use `mip`:

    $ docker run --rm micropython/unix -m mip install aioble

#### Keeping this image up to date

New images are built and pushed automatically — a scheduled GitHub Actions workflow (`.github/workflows/publish.yml`) checks daily for new MicroPython releases and, if one hasn't been published yet, builds and pushes both `micropython/unix:<version>` and `micropython/unix:latest`. The MicroPython version is passed to the build as a Docker build ARG, so the `Dockerfile` itself never needs to be edited for a new release.

To build a specific version locally instead of relying on the default pinned in the `Dockerfile`:

    docker build --build-arg MICROPY_VERSION=v1.29.0 -t micropython-unix .
