GOVUK_ROOT_DIR="${HOME}/govuk"

APPS ?= $(shell ls */Makefile | xargs -L 1 dirname)

default: build setup clean

clone: $(addprefix ../,$(APPS))

pull:
	for repo in $(APPS); do \
		if [ -d "${GOVUK_ROOT_DIR}/$$repo" ]; then \
			(cd ${GOVUK_ROOT_DIR}/$$repo && echo $$repo && git pull origin master:master); \
		fi \
	done

build:
	bin/govuk-docker build

setup: $(addsuffix _setup,$(APPS))

clean:
	bin/govuk-docker stop
	bin/govuk-docker prune

test:
	# Test that the docker-compose config is valid. This will error if there are errors
	# in the YAML files, or incompatible features are used.
	bin/govuk-docker config

../%: % %/Makefile
	if [ ! -d "${GOVUK_ROOT_DIR}/$<" ]; then \
		echo "$<" && git clone "git@github.com:alphagov/$<.git" "${GOVUK_ROOT_DIR}/$<"; \
	fi

include $(shell ls */Makefile)
