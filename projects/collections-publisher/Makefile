collections-publisher: bundle-collections-publisher publishing-api content-store link-checker-api
	$(GOVUK_DOCKER_RUN) $@-lite bin/rake db:prepare
	$(GOVUK_DOCKER_RUN) $@-lite env RAILS_ENV=test bin/rake db:prepare
	$(GOVUK_DOCKER_RUN) $@-lite yarn
