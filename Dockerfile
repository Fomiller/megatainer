FROM ubuntu:latest

SHELL ["/bin/bash", "-c"]
ARG USER=root
ENV DEBIAN_FRONTEND=noninteractive
ENV GOPATH=$HOME/go
ENV GOBIN=$HOME/go/bin
ENV CARGOBIN=$HOME/.cargo/bin
ENV CARGO_UNSTABLE_SPARSE_REGISTRY=true
ENV AWS_DEFAULT_PROFILE="default"
ENV AWS_ASSUME_PROFILE="default"
ENV PATH=$PATH:/usr/local/go/bin:/root/.please/bin:/.local/bin:$GOPATH:$GOBIN:$CARGOBIN

COPY scripts ./scripts/
RUN chmod +x -R ./scripts/
RUN ./scripts/install_tools.sh && \
    rm -rf ./scripts/
