search-admin: bundle-search-admin publishing-api search-api
	$(GOVUK_DOCKER) run $@-lite bin/rake db:setup
	$(GOVUK_DOCKER) run $@-lite env RAILS_ENV=test bin/rake db:setup
	$(GOVUK_DOCKER) run $@-lite bin/rails runner 'User.first || User.create'
	$(GOVUK_DOCKER) run $@-lite yarn
