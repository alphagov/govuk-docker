datagovuk_publish: bundle-datagovuk_publish
	$(GOVUK_DOCKER) run $@-lite bin/rake db:prepare
	$(GOVUK_DOCKER) run $@-lite env RAILS_ENV=test bin/rake db:prepare
