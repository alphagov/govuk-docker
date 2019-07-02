FROM ruby:2.6.3
RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y vim
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb 2>&1 && apt install -y ./google-chrome*.deb

RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 2>&1
RUN tar -xf phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN cp phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update -qq && apt-get install -y nodejs

RUN apt-get clean

RUN useradd -m build
USER build

RUN mkdir /home/build/.chromedriver-helper

ENV EDITOR=vim
