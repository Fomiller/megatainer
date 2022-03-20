FROM ubuntu:latest

RUN apt-get update && apt-get upgrade

ENV PATH=$PATH:/usr/local/go/bin:/root/.please/bin
# install utility dependecies
RUN apt-get install -y wget
RUN apt-get install -y curl
RUN apt-get install -y unzip && apt-get install -y zip

# install python3.9
RUN apt-get update && apt-get install -y software-properties-common gcc && add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update && apt-get install -y python3.9 python3-distutils python3-pip python3-apt
RUN apt-get install python-is-python3

# install golang
RUN wget https://golang.org/dl/go1.18.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.linux-amd64.tar.gz

# install terraform
RUN curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash

# install aws
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# install please.build
COPY ./scripts/install_tools.sh .
# ENV PATH=$PATH:/root/.please/bin
RUN chmod +x ./install_tools.sh && \
  ./install_tools.sh && \
  rm ./install_tools.sh

