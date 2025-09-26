whitehall: bundle-whitehall asset-manager link-checker-api publishing-api signon
	$(GOVUK_DOCKER) run -rm $@-lite bin/rake db:prepare
	$(GOVUK_DOCKER) run -rm $@-lite env RAILS_ENV=test bin/rake db:prepare
	$(GOVUK_DOCKER) run -rm $@-lite yarn
	$(GOVUK_DOCKER) run -rm $@-lite rails taxonomy:populate_end_to_end_test_data
	$(GOVUK_DOCKER) run -rm $@-lite rails taxonomy:rebuild_cache
	$(GOVUK_DOCKER) run -rm $@-lite yarn playwright install --with-deps
