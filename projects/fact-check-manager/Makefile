fact-check-manager: bundle-fact-check-manager publishing-api signon
	$(GOVUK_DOCKER) run --rm $@-lite bin/rake db:setup
	$(GOVUK_DOCKER) run --rm $@-lite env RAILS_ENV=test bin/rake db:setup
	$(GOVUK_DOCKER) run --rm $@-lite yarn
