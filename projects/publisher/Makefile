publisher: bundle-publisher publishing-api link-checker-api signon
	$(GOVUK_DOCKER_RUN) $@-lite bin/rake db:setup
	$(GOVUK_DOCKER_RUN) $@-lite env RAILS_ENV=test bin/rake db:setup
	$(GOVUK_DOCKER_RUN) $@-lite yarn
