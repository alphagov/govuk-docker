FROM ruby:2.6.3
RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y libpq-dev libxml2-dev libxslt1-dev vim
RUN apt-get install -y postgresql-client
RUN apt-get clean

RUN useradd -m build
USER build

ENV EDITOR=vim
