FROM ruby:2.6.3
RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y build-essential libpq-dev libxml2-dev libxslt1-dev && apt-get clean

RUN useradd -m build
USER build
