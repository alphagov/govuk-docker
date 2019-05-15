FROM ruby:2.6.3

RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y build-essential
RUN apt-get install -y libxss1 libappindicator1 libindicator7
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && apt install -y ./google-chrome*.deb

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update -qq && apt-get install -y nodejs

RUN apt-get clean

RUN useradd -m build
USER build

RUN mkdir /home/build/.chromedriver-helper
