whitehall: bundle-whitehall asset-manager link-checker-api publishing-api signon
	$(GOVUK_DOCKER_RUN) $@-lite bin/rake db:prepare
	$(GOVUK_DOCKER_RUN) $@-lite env RAILS_ENV=test bin/rake db:prepare
	$(GOVUK_DOCKER_RUN) $@-lite yarn
	$(GOVUK_DOCKER_RUN) $@-lite rails taxonomy:populate_end_to_end_test_data
	$(GOVUK_DOCKER_RUN) $@-lite rails taxonomy:rebuild_cache
	$(GOVUK_DOCKER_RUN) $@-lite yarn playwright install --with-deps
