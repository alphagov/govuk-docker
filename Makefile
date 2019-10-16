GOVUK_ROOT_DIR   ?= $(HOME)/govuk
GOVUK_DOCKER_DIR ?= $(GOVUK_ROOT_DIR)/govuk-docker
GOVUK_DOCKER     ?= $(GOVUK_DOCKER_DIR)/bin/govuk-docker

APPS ?= $(shell ls ${GOVUK_DOCKER_DIR}/services/*/Makefile | xargs -L 1 dirname | xargs -L 1 basename)

# Best practice to ensure these targets always execute, even if a
# file like 'clone' exists in the current directory.
.PHONY: clone pull test all-apps

default:
	@echo "Run 'make APP-NAME' to set up an app and its dependencies."
	@echo
	@echo "For example:"
	@echo "    make content-publisher"

clone: $(addprefix $(GOVUK_ROOT_DIR)/,$(APPS))

pull:
	echo $(APPS) | cut -d/ -f3 | xargs -P8 -n1 ./bin/update-git-repo.sh

test:
	# Linting
	bundle exec rubocop . --parallel

	# Run the tests for the govuk-docker CLI
	bundle exec rspec

	# Test that the docker-compose config is valid. This will error if there are errors
	# in the YAML files, or incompatible features are used.
	$(GOVUK_DOCKER) compose config > /dev/null

# This will be slow and may repeat work, so generally you don't want
# to run this.
all-apps: $(APPS)

bundle-%: clone-%
	$(GOVUK_DOCKER) compose build $*-lite
	$(GOVUK_DOCKER) compose run $*-lite rbenv install -s
	$(GOVUK_DOCKER) compose run $*-lite sh -c 'gem install --conservative --no-document bundler -v $$(grep -A1 "BUNDLED WITH" Gemfile.lock | tail -1)'
	$(GOVUK_DOCKER) compose run $*-lite bundle

clone-%:
	@if [ ! -d "${GOVUK_ROOT_DIR}/$*" ]; then \
		echo "$*" && git clone "git@github.com:alphagov/$*.git" "${GOVUK_ROOT_DIR}/$*"; \
	fi

include $(shell ls ${GOVUK_DOCKER_DIR}/services/*/Makefile)
