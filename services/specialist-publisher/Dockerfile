FROM ruby:2.6.3

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y vim nodejs

# Dependencies required for Capybara Webkit
RUN apt-get install -y qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x

# Dependencies required for Google Chrome
RUN apt-get install -y qt5-default libnss3-dev libxss1 libappindicator1 libindicator7
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && apt install -y ./google-chrome*.deb

RUN apt-get clean

RUN useradd -m build
USER build

ENV EDITOR=vim
