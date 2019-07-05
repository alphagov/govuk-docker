FROM ruby:2.6.3
RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y vim
RUN apt-get install -y libxss1 libappindicator1 libindicator7
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb 2>&1 && \
    apt install -y ./google-chrome*.deb && \
    rm ./google-chrome*.deb

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
