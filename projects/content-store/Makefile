content-store: bundle-content-store router-api govuk-content-schemas
	$(GOVUK_DOCKER) run $@-lite bin/rake db:create
	$(GOVUK_DOCKER) run $@-lite bin/rails runner 'User.first || User.create'
