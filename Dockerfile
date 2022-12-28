FROM ubuntu:latest

ARG USER=root
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH=$PATH:/usr/local/go/bin:/root/.please/bin:/.local/bin
ENV AWS_DEFAULT_PROFILE="saml"

COPY ./scripts/install_tools.sh .

RUN chmod +x ./install_tools.sh && \
  ./install_tools.sh && \
  rm ./install_tools.sh

# skipping plz install until further arm64 support
# COPY ./scripts/plz_install.sh .
# COPY ./scripts/plzw.sh .

# RUN chmod +x ./plz_install.sh && \
#   ./plz_install.sh && \
#   rm ./plz_install.sh
