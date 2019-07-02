GOVUK_ROOT_DIR="${HOME}/govuk"

REPOS ?= $(shell ls */Makefile | xargs -L 1 dirname)

default: clone build setup clean

clone:
	for repo in $(REPOS); do \
		if [ ! -d "${GOVUK_ROOT_DIR}/$$repo" ]; then \
			echo $$repo && git clone git@github.com:alphagov/$$repo.git ${GOVUK_ROOT_DIR}/$$repo; \
		fi \
	done

pull:
	for repo in $(REPOS); do \
		if [ -d "${GOVUK_ROOT_DIR}/$$repo" ]; then \
			(cd ${GOVUK_ROOT_DIR}/$$repo && echo $$repo && git pull origin master:master); \
		fi \
	done

build:
	bin/govuk-docker build

setup:
	for repo in $(REPOS); do \
		make -f $$repo/Makefile; \
	done
	bin/govuk-docker run whitehall-e2e rake taxonomy:populate_end_to_end_test_data

clean:
	bin/govuk-docker stop
	bin/govuk-docker prune

test:
	# Test that the docker-compose config is valid. This will error if there are errors
	# in the YAML files, or incompatible features are used.
	bin/govuk-docker config

	# Test that some builds work from scratch for services with different kinds of Dockerfile.
	# This will error if a build fails for some reason.
	bin/govuk-docker build --no-cache --parallel \
		asset-manager-default \
		content-publisher-default \
		signon-default
