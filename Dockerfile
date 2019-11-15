FROM debian:9-slim

LABEL maintainer "trick@vanstaveren.us"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    devscripts \
    dh-make

WORKDIR /src

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    wget \
    libusb-1.0-0-dev \
    && \
    wget -O mochad-0.1.16.tar.gz http://sourceforge.net/projects/mochad/files/latest/download && \
    tar xf mochad-0.1.16.tar.gz

ENV USER=root

RUN cd mochad-* && \
    dh_make --single --yes --file ../mochad-0.1.16.tar.gz && \
    debuild -us -uc

ENTRYPOINT ["bash"]

# fixme: i'm sure there's a way to extract a build artifact but this'll do for now...
# then run the container once: docker run mochad:latest
# and quit. then run on the host:
# docker cp <containername>:/src/mochad_0.1.16-1_amd64.deb .
