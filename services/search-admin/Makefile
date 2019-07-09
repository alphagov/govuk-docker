search-admin: bundle-search-admin publishing-api search-api
	$(GOVUK_DOCKER) compose run $@-lite sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
	$(GOVUK_DOCKER) compose run $@-lite bin/rails runner 'User.first || User.create'
