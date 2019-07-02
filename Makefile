GOVUK_ROOT_DIR ?= "${HOME}/govuk"

# This is a Makefile best practice to say that these are not file
# names.  For example, if you were to create a file called "clean",
# then `make clean` should still invoke the rule, it shouldn't do
# this:
#
#     $ touch clean
#     $ make clean
#     make: `clean' is up to date.
.PHONY: clone pull clean test

APPS ?= $(shell ls services/*/Makefile | xargs -L 1 dirname)

default:
	@echo "Run 'make APP-NAME' to set up an app and its dependencies."
	@echo
	@echo "For example:"
	@echo "    make content-publisher"

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

# Clone an app, for example:
#
#     make ../content-publisher
#
# The 'services/%/Makefile' bit is to double-check that this is a git
# repository, as all of our apps have a Makefile.
../%: services/%/Makefile
	if [ ! -d "${GOVUK_ROOT_DIR}/$*" ]; then \
		echo "$*" && git clone "git@github.com:alphagov/$*.git" "${GOVUK_ROOT_DIR}/$*"; \
	fi

include $(shell ls services/*/Makefile)
