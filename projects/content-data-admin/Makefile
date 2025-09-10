content-data-admin: bundle-content-data-admin content-data-api
	$(GOVUK_DOCKER) run --rm $@-lite bin/rake db:prepare
	$(GOVUK_DOCKER) run --rm $@-lite env RAILS_ENV=test bin/rake db:prepare
	$(GOVUK_DOCKER) run --rm $@-lite yarn
