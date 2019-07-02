FROM ruby:2.6.3

RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y vim

RUN export VERSION=2.1.1 && \
    wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$VERSION-linux-x86_64.tar.bz2 2>&1 && \
    tar -vxf phantomjs-$VERSION-linux-x86_64.tar.bz2 && \
    cp -v phantomjs-$VERSION-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs && \
    rm -vr phantomjs-$VERSION-linux-x86_64

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update -qq && apt-get install -y nodejs

RUN useradd -m build
USER build

ENV EDITOR=vim
