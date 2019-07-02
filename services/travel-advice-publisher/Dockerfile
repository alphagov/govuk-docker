FROM ruby:2.6.3

RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y vim && apt-get clean
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && apt install -y ./google-chrome*.deb
# for capybara-webkit
RUN apt-get update -qq && apt-get install -y libqtwebkit4 libqt4-dev xvfb
RUN gem install foreman

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update -qq && apt-get install -y nodejs

RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar -xf phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN cp phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs

RUN apt-get clean

RUN useradd -m build
USER build

ENV EDITOR=vim
