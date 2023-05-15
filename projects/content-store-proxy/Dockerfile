# content-store-proxy is a very lightweight Sinatra app
# with no database, and no cucumber/other end-to-end tests.
# So it doesn't need many of the standard packages.

# Install packages for building ruby
FROM buildpack-deps


# Install rbenv to manage ruby versions
RUN git clone https://github.com/rbenv/rbenv.git /rbenv
RUN git clone https://github.com/rbenv/ruby-build.git /rbenv/plugins/ruby-build
RUN /rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/shims:/rbenv/bin:$PATH
ENV BUNDLE_SILENCE_ROOT_WARNING 1
