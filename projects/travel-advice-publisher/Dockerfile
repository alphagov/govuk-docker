# Install packages for building ruby
FROM buildpack-deps

# Install chrome and its dependencies
RUN apt-get update -qq && apt-get install -y libxss1 libappindicator1 libindicator7
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb 2>&1 && \
   apt install -y ./google-chrome*.deb && \
    rm ./google-chrome*.deb

# Enable no-sandbox for chrome so that it can run as a root user
ENV GOVUK_TEST_CHROME_NO_SANDBOX 1

# Install node / yarn
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn nodejs

# Install phantomjs for some projects
RUN export VERSION=2.1.1 && \
    wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$VERSION-linux-x86_64.tar.bz2 2>&1 && \
    tar -vxf phantomjs-$VERSION-linux-x86_64.tar.bz2 && \
    cp -v phantomjs-$VERSION-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs && \
    rm -vr phantomjs-$VERSION-linux-x86_64

# Install rbenv to manage ruby versions
RUN git clone https://github.com/sstephenson/rbenv.git /rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /rbenv/plugins/ruby-build
RUN /rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/shims:/rbenv/bin:$PATH
ENV BUNDLE_SILENCE_ROOT_WARNING 1

# Install dependencies for capybara-webkit
RUN apt-get update -qq && apt-get install -y libqtwebkit4 libqt4-dev xvfb
