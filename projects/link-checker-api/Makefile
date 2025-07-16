link-checker-api: bundle-link-checker-api
	$(GOVUK_DOCKER) run --rm $@-lite bin/rake db:prepare
	$(GOVUK_DOCKER) run --rm $@-lite env RAILS_ENV=test bin/rake db:prepare
