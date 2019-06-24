FROM ruby:2.6.3

RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y build-essential && apt-get clean vim

RUN useradd -m build
USER build

ENV EDITOR=vim
