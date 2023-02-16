FROM ubuntu:latest

ARG USER=root
ENV DEBIAN_FRONTEND=noninteractive
ENV GOPATH=$HOME/go
ENV PATH=$GOPATH/bin:$PATH
ENV PATH=$PATH:/usr/local/go/bin:/root/.please/bin:/.local/bin
ENV AWS_DEFAULT_PROFILE="default"
ENV AWS_ASSUME_PROFILE="default"

COPY ./scripts ./
RUN ls
RUN ls ./scripts/

RUN chmod +x ./scripts/install_tools.sh ./scripts/go_tools.sh && \
    ./scripts/install_tools.sh && \
    ./scripts/go_tools && \
    rm -rf ./scripts/
