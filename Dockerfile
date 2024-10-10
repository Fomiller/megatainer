FROM alpine:latest

ARG TARGETARCH
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETVARIENT

ENV HOME=/home
ENV GOPATH=$HOME/go
ENV GOBIN=$HOME/go/bin
ENV CARGOBIN=$HOME/.cargo/bin
ENV LOCALBIN=$HOME/.local/bin
ENV PATH=$PATH:/usr/local/go/bin:$LOCALBIN:$GOPATH:$GOBIN:$CARGOBIN:$NVIMBIN
ENV PS1="\[\e[32m\][\[\e[m\]\[\e[31m\]\u\[\e[m\]\[\e[33m\]@\[\e[m\]\[\e[32m\]\${HOSTNAME:0:6}\[\e[m\]:\[\e[36m\]\w\[\e[m\]\[\e[32m\]]\[\e[m\]\[\e[32;47m\]\[\e[m\] "
ENV EDITOR=nvim
ENV SHELL=/bin/bash

COPY scripts ./scripts/
COPY .bashrc $HOME/.bashrc

# setup directories
RUN mkdir -p $HOME/.config \
    mkdir -p $HOME/.local/bin

# # install utility dependecies
RUN apk update && \
    apk upgrade && \
    apk add \
    aws-cli \
    bash \
    bat \
    build-base \
    cmake \
    curl \
    exa \
    fzf \
    git \
    gnupg \
    go \
    helm \ 
    httpie \
    jq \
    just \
    musl-dev \
    neovim \
    python3 \
    ripgrep \
    shadow \
    sudo \
    unzip \
    yq \
    zip \
    zoxide \
    zsh \
    rustup && rustup-init -y && source "$HOME/.cargo/env"


# install additional tools
RUN chmod +x -R ./scripts/ &&\
    ./scripts/install_tools.sh && \
    rm -rf ./scripts/

ENTRYPOINT [ "/bin/bash" ]
