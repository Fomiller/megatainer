FROM ubuntu:latest

ARG TARGETARCH
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETVARIENT
ARG GO_VERSION=1.21.4
ARG RUST_VERSION=1.74.0
ARG PYTHON_VERSION=3.12

ENV DEBIAN_FRONTEND=noninteractive
ENV GOPATH=$HOME/go
ENV GOBIN=$HOME/go/bin
ENV CARGOBIN=$HOME/.cargo/bin
ENV LOCALBIN=$HOME/.local/bin
ENV PATH=$PATH:/usr/local/go/bin:$LOCALBIN:$GOPATH:$GOBIN:$CARGOBIN
ENV CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse

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
RUN echo "======> Downloading and installing python ${PYTHON_VERSION}" && \
    apt-get update && \
    apt-get install -y software-properties-common gcc && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python${PYTHON_VERSION} \
    python3-distutils \
    python3-pip \
    python3-apt \
    python-is-python3

# install golang
RUN echo "======> Downloading and installing golang" && \
    wget -nv https://golang.org/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz && \
    rm -rf /usr/local/go && tar -C /usr/local -xzf go${GO_VERSION}.linux-${TARGETARCH}.tar.gz 

# install rust
RUN echo "======> Downloading and installing rust" && \
    curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    . $HOME/.cargo/env

# install aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "awscliv2.zip" && \
    unzip -qq awscliv2.zip && \
    ./aws/install 

# install just build tool
RUN curl \
    --proto '=https' \
    --tlsv1.2 \
    -sSf https://just.systems/install.sh | bash -s -- --to /.local/bin 

# install additional tools
COPY scripts ./scripts/
RUN chmod +x -R ./scripts/ &&\
    ./scripts/install_tools.sh && \
    rm -rf ./scripts/

