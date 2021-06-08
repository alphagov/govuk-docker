email-alert-api: bundle-email-alert-api
	$(GOVUK_DOCKER) run $@-lite bin/rake db:prepare
	$(GOVUK_DOCKER) run $@-lite env RAILS_ENV=test bin/rake db:prepare
