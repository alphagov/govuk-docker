# Install chrome and its dependencies
RUN apt-get update -qq && apt-get install -y libxss1 libappindicator1 libindicator7
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb 2>&1 && \
   apt install -y ./google-chrome*.deb && \
    rm ./google-chrome*.deb

# Dependencies required for Capybara Webkit
RUN apt-get install -y qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x
