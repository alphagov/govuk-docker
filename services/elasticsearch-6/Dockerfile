# search-api in its current state has a hard dependency on Elasticsearch 6, which doesn't have any
# official images supporting arm64 and probably never will. Until it migrates away from v6, we need
# to have a functioning development environment that has a reasonable degree of parity with the
# production service, while working on both architectures that developers will commonly use.
#
# This Dockerfile allows us to have this by manually setting up Elasticsearch v6 using a JRE image
# that supports both x86_64 and arm64.

FROM eclipse-temurin:8-jre

ARG ELASTICSEARCH_VERSION=6.7.2

# As of Ubuntu 24.04, the official Docker image (which the Eclipse Temurin one is based on) ships
# with an existing non-root user called "ubuntu"
ARG USERNAME=ubuntu

# Install required tooling
RUN apt update && apt install -y curl

# Get Elasticsearch
WORKDIR /usr
RUN curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz
RUN tar -xvf elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz
RUN mv elasticsearch-${ELASTICSEARCH_VERSION} elasticsearch

# Apply our custom configuration file
ADD elasticsearch.yml /usr/elasticsearch/config/elasticsearch.yml

# Ensure regular user owns Elasticsearch directory
RUN chown -R ${USERNAME}: elasticsearch

USER ${USERNAME}
CMD /usr/elasticsearch/bin/elasticsearch
