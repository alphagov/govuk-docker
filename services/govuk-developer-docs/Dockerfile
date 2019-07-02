FROM ruby:2.6.3
RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y vim

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update -qq && apt-get install -y nodejs

RUN useradd -m build
USER build

ENV EDITOR=vim
