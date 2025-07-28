GOVUK_ROOT_DIR   ?= $(HOME)/govuk
GOVUK_DOCKER_DIR ?= $(GOVUK_ROOT_DIR)/govuk-docker
GOVUK_DOCKER     ?= $(GOVUK_DOCKER_DIR)/exe/govuk-docker
SHELLCHECK       ?= shellcheck

# Best practice to ensure these targets always execute, even if a
# file like 'test' exists in the current directory.
.PHONY: lint test

default:
	@echo "Run 'make APP-NAME' to set up an app and its dependencies."
	@echo
	@echo "For example:"
	@echo "    make content-publisher"

test-local: test-scripts
	$(GOVUK_DOCKER) run --rm govuk-docker-lite bundle exec rubocop
	$(GOVUK_DOCKER) run --rm govuk-docker-lite bundle exec rspec

test-ci: test-scripts
	bundle exec rubocop
	bundle exec rspec

test-scripts:
	# Test that the docker-compose config is valid. This will error if there are errors
	# in the YAML files, or incompatible features are used.
	$(GOVUK_DOCKER) config > /dev/null

	# Validate shell scripts
	$(SHELLCHECK) $(shell ls ${GOVUK_DOCKER_DIR}/bin/*.sh ${GOVUK_DOCKER_DIR}/exe/*)

bundle-%: clone-% branch-checks-%
	$(GOVUK_DOCKER) build $*-lite
	$(GOVUK_DOCKER) run --rm $*-lite rbenv install -s || ($(GOVUK_DOCKER) build --no-cache $*-lite; $(GOVUK_DOCKER) run --rm $*-lite rbenv install -s)
	if [ -f "${GOVUK_ROOT_DIR}/$*/Gemfile.lock" ]; then $(GOVUK_DOCKER) run --rm $*-lite sh -c 'gem install --conservative --no-document bundler -v $$(grep -A1 "BUNDLED WITH" Gemfile.lock | tail -1)'; fi
	$(GOVUK_DOCKER) run --rm $*-lite bundle

clone-%:
	@if [ ! -d "${GOVUK_ROOT_DIR}/$*/.git" ]; then \
		echo "$*" && git clone "git@github.com:alphagov/$*.git" "${GOVUK_ROOT_DIR}/$*"; \
	fi

branch-checks-%:
	$(GOVUK_DOCKER_DIR)/bin/branch_checks.sh $*

include $(shell ls ${GOVUK_DOCKER_DIR}/projects/*/Makefile)
