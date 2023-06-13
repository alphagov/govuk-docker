# Install packages for building ruby
# TODO: Change from bullseye to stable tag once we've resolved problems with Ruby and SSL
#       See https://github.com/alphagov/govuk-docker/pull/666 for more info.
FROM buildpack-deps:bullseye

# Install chromium browser and its webdriver
RUN apt-get update -qq && apt-get install -y chromium chromium-driver

# Enable no-sandbox for chrome so that it can run as a root user
ENV GOVUK_TEST_CHROME_NO_SANDBOX 1

# Install node / yarn
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn nodejs
RUN yarn config set cache-folder /root/.yarn/

# Install rbenv to manage ruby versions
RUN git clone https://github.com/rbenv/rbenv.git /rbenv
RUN git clone https://github.com/rbenv/ruby-build.git /rbenv/plugins/ruby-build
RUN /rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/shims:/rbenv/bin:$PATH
ENV BUNDLE_SILENCE_ROOT_WARNING 1

# Install virus scanner utility
# and `less` for paginated output in 'rails console' and 'binding.pry'
RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y clamav less
RUN ln -sf /usr/bin/clamscan /usr/bin/govuk_clamscan
