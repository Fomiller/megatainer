FROM ubuntu:latest

ARG USER=root

ENV PATH=$PATH:/usr/local/go/bin:/root/.please/bin
ENV AWS_DEFAULT_PROFILE="saml"

COPY ./scripts/install_tools.sh .

RUN chmod +x ./install_tools.sh && \
  ./install_tools.sh && \
  rm ./install_tools.sh
