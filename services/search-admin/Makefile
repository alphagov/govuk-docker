search-admin: bundle-search-admin publishing-api search-api
	$(GOVUK_DOCKER) run $@-lite sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
	$(GOVUK_DOCKER) run $@-lite bin/rails runner 'User.first || User.create'
