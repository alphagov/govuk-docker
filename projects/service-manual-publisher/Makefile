service-manual-publisher: bundle-service-manual-publisher
	$(GOVUK_DOCKER) run $@-lite bin/rake db:prepare
	$(GOVUK_DOCKER) run $@-lite env RAILS_ENV=test bin/rake db:prepare
	$(GOVUK_DOCKER) run $@-lite yarn
