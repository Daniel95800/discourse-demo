FROM ruby:2.2.1
MAINTAINER flo@codeship.com

RUN \
  apt-get update -y && \
  apt-get upgrade -y && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    apt-utils \
    vim git wget libfreetype6 libfontconfig bzip2 time python-pip
RUN pip install awscli
RUN mkdir -p /install
WORKDIR /install
ADD Gemfile ./Gemfile
ADD Gemfile.lock ./Gemfile.lock
ADD vendor ./vendor
RUN bundle install -j24
RUN gem install parallel_tests

# Env
ENV PHANTOMJS_VERSION 1.9.7

RUN \
  mkdir -p /srv/var && \
  wget -q --no-check-certificate -O /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 https://s3.amazonaws.com/codeship.io/checkbot/archives/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
  tar -xjf /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 -C /tmp && \
  rm -f /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
  mv /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/ /srv/var/phantomjs && \
  ln -s /srv/var/phantomjs/bin/phantomjs /usr/bin/phantomjs

# Commands

WORKDIR /app
