FROM ruby:2.6.3
RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y build-essential

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update -qq && apt-get install -y nodejs

RUN apt-get clean

RUN useradd -m build
USER build
