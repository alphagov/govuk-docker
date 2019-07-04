# Standard Dockerfile for GOV.UK services. Random service-specific stuff should *not*
# go in this file. Instead, you should copy this file into the directory for the
# service and make any changes to it there.

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

RUN git clone https://github.com/sstephenson/rbenv.git /rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /rbenv/plugins/ruby-build
RUN /rbenv/plugins/ruby-build/install.sh
ENV PATH /rbenv/bin:$PATH
ENV PATH /rbenv/shims:${PATH}
RUN mkdir /rbenv/versions /rbenv/shims

RUN useradd -m build
RUN chown build /rbenv/versions /rbenv/shims
USER build
ENV RBENV_ROOT /rbenv
