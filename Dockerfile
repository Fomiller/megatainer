FROM ubuntu:latest

SHELL ["/bin/bash", "-c"]
ARG USER=root
ARG TARGETARCH
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETVARIENT
ARG GO_VERSION=1.20
ENV DEBIAN_FRONTEND=noninteractive
ENV GOPATH=$HOME/go
ENV GOBIN=$HOME/go/bin
ENV CARGOBIN=$HOME/.cargo/bin
ENV AWS_PROFILE=default
ENV AWS_ASSUME_PROFILE=default
ENV PATH=$PATH:/usr/local/go/bin:/root/.please/bin:/.local/bin:$GOPATH:$GOBIN:$CARGOBIN

# install utility dependecies
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get -y install wget \
    curl \
    git \
    git \
    build-essential \
    zip \
    unzip

# install python3.9
RUN echo "======> Downloading and installing python" && \
    apt-get update && \
    apt-get install -y software-properties-common gcc && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.9 \
    python3-distutils \
    python3-pip \
    python3-apt && \
    apt-get install python-is-python3

# install golang
RUN echo "======> Downloading and installing golang" && \
    wget -nv https://golang.org/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz && \
    rm -rf /usr/local/go && tar -C /usr/local -xzf go${GO_VERSION}.linux-${TARGETARCH}.tar.gz 

RUN echo "======> Downloading and installing rust" && \
    curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    source $HOME/.cargo/env

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "awscliv2.zip" && \
    unzip -qq awscliv2.zip && \
    sh ./aws/install 

COPY scripts ./scripts/
RUN chmod +x -R ./scripts/ &&\
    ./scripts/install_tools.sh && \
    rm -rf ./scripts/

