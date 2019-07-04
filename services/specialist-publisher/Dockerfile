# Install packages for building ruby
FROM buildpack-deps

# Install chrome and its dependencies
RUN apt-get update -qq && apt-get install -y libxss1 libappindicator1 libindicator7
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb 2>&1 && \
   apt install -y ./google-chrome*.deb && \
    rm ./google-chrome*.deb

# Install node / yarn
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn nodejs

# Install phantomjs for some services
RUN export VERSION=2.1.1 && \
    wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$VERSION-linux-x86_64.tar.bz2 2>&1 && \
    tar -vxf phantomjs-$VERSION-linux-x86_64.tar.bz2 && \
    cp -v phantomjs-$VERSION-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs && \
    rm -vr phantomjs-$VERSION-linux-x86_64

# Install rbenv to manage ruby versions
RUN git clone https://github.com/sstephenson/rbenv.git /rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /rbenv/plugins/ruby-build
RUN /rbenv/plugins/ruby-build/install.sh
ENV PATH /rbenv/bin:$PATH

# Dependencies required for Capybara Webkit
RUN apt-get install -y qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x

RUN useradd -m build
ENV PATH /home/build/.rbenv/shims:${PATH}
USER build
