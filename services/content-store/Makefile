content-store: bundle-content-store router-api govuk-content-schemas
	$(GOVUK_DOCKER) compose run $@-lite bin/rake db:create
	$(GOVUK_DOCKER) compose run $@-lite bin/rails runner 'User.first || User.create'
	$(GOVUK_DOCKER) compose run $@-app-draft bin/rake db:create
	$(GOVUK_DOCKER) compose run $@-app-draft bin/rails runner 'User.first || User.create'
