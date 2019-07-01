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

setup: asset-manager_setup content-data-admin_setup content-publisher_setup content-store_setup \
	content-tagger_setup government-frontend_setup govspeak_setup govuk-developer-docs_setup \
	govuk-lint_setup govuk_app_config_setup govuk_publishing_components_setup \
	miller-columns-element_setup plek_setup publishing-api_setup router_setup router-api_setup \
	signon_setup static_setup support_setup support-api_setup whitehall_setup
	bin/govuk-docker run whitehall-e2e rake taxonomy:populate_end_to_end_test_data

clean:
	bin/govuk-docker stop
	bin/govuk-docker prune

test:
	# Test that the docker-compose config is valid. This will error if there are errors
	# in the YAML files, or incompatible features are used.
	bin/govuk-docker config

include $(shell ls */Makefile)
