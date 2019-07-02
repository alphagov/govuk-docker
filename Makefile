GOVUK_ROOT_DIR ?= "${HOME}/govuk"

.PHONY: clone pull clean test

APPS ?= $(shell ls services/*/Makefile | xargs -L 1 dirname)

default:
	@echo "Run 'make build' to bootstrap govuk-docker"
	@echo "Or 'make APP-NAME' to set up an app"

clone: $(addprefix ../,$(APPS))

pull:
	for repo in $(APPS); do \
		if [ -d "${GOVUK_ROOT_DIR}/$$repo" ]; then \
			(cd ${GOVUK_ROOT_DIR}/$$repo && echo $$repo && git pull origin master:master); \
		fi \
	done

clean:
	bin/govuk-docker stop
	bin/govuk-docker prune

test:
	# Test that the docker-compose config is valid. This will error if there are errors
	# in the YAML files, or incompatible features are used.
	bin/govuk-docker config

../%: %/Makefile
	if [ ! -d "${GOVUK_ROOT_DIR}/$*" ]; then \
		echo "$*" && git clone "git@github.com:alphagov/$*.git" "${GOVUK_ROOT_DIR}/$*"; \
	fi

include $(shell ls services/*/Makefile)
