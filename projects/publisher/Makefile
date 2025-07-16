publisher: bundle-publisher publishing-api link-checker-api signon
	$(GOVUK_DOCKER) run --rm $@-lite bin/rake db:setup
	$(GOVUK_DOCKER) run --rm $@-lite env RAILS_ENV=test bin/rake db:setup
	$(GOVUK_DOCKER) run --rm $@-lite yarn
