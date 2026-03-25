# Install packages for building ruby
FROM buildpack-deps:trixie

# Install chromium browser and its webdriver
RUN apt-get update -qq && apt-get install -y chromium chromium-driver

# Enable no-sandbox for chrome so that it can run as a root user
ENV GOVUK_TEST_CHROME_NO_SANDBOX 1

# Install node / yarn
RUN curl -sL https://deb.nodesource.com/setup_22.x | bash -
RUN mkdir -p /etc/apt/keyrings && \
  curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /etc/apt/keyrings/yarn-archive-keyring.gpg && \
  chmod a+r /etc/apt/keyrings/yarn-archive-keyring.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/yarn-archive-keyring.gpg] https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
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
