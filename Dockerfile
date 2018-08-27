# Stage 0, based on Node.js, to build and compile Angular
FROM alpine:3.7 as node
MAINTAINER Auktavian Garrett <auktavian.garrett@gmail.com>

ARG VERSION=2.2.70
ARG GEM_SOURCE=https://rubygems.org

RUN apk update && apk upgrade && \
    apk add --no-cache curl wget bash \
    ruby-dev ruby-bundler openssh-keygen ansible unzip build-base libxml2-dev libffi-dev && \
    gem install --no-document --source ${GEM_SOURCE} --version ${VERSION} inspec && \
    inspec version && apk del build-base

RUN wget https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip
RUN unzip terraform_0.11.8_linux_amd64.zip -d /usr/bin
RUN terraform version

COPY ./ /app/
WORKDIR /app
