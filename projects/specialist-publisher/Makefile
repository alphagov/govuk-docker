specialist-publisher: bundle-specialist-publisher asset-manager publishing-api email-alert-api
	$(GOVUK_DOCKER) run --rm $@-lite bin/rake db:setup
	$(GOVUK_DOCKER) run --rm $@-lite env RAILS_ENV=test bin/rake db:setup
	$(GOVUK_DOCKER) run --rm $@-lite yarn
