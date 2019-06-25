GOVUK_ROOT_DIR="${HOME}/govuk"

default: clone build setup clean

clone:
	for repo in $(shell ls */Makefile | xargs -L 1 dirname); do \
		if [ ! -d "${GOVUK_ROOT_DIR}/$$repo" ]; then \
			echo $$repo && git clone git@github.com:alphagov/$$repo.git ${GOVUK_ROOT_DIR}/$$repo; \
		fi \
	done

pull:
	for repo in $(shell ls */Makefile | xargs -L 1 dirname); do \
		if [ -d "${GOVUK_ROOT_DIR}/$$repo" ]; then \
			(cd ${GOVUK_ROOT_DIR}/$$repo && echo $$repo && git pull origin master:master); \
		fi \
	done

build:
	govuk-docker build

setup:
	for repo in $(shell ls */Makefile | xargs -L 1 dirname); do \
		make -f $$repo/Makefile; \
	done
	govuk-docker run whitehall-e2e rake taxonomy:populate_end_to_end_test_data

clean:
	govuk-docker stop
	govuk-docker prune
