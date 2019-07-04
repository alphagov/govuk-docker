FROM buildpack-deps

RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y clamav
RUN ln -sf /usr/bin/clamscan /usr/bin/govuk_clamscan

RUN git clone https://github.com/sstephenson/rbenv.git /rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /rbenv/plugins/ruby-build
RUN /rbenv/plugins/ruby-build/install.sh
ENV PATH /rbenv/bin:$PATH
ENV PATH /rbenv/shims:${PATH}
RUN mkdir /rbenv/versions
RUN chmod o+w /rbenv/versions

RUN useradd -m build
USER build
ENV RBENV_ROOT /rbenv
