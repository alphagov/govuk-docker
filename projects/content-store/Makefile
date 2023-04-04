content-store: bundle-content-store router-api publishing-api
	$(GOVUK_DOCKER) run $@-lite bin/rake db:setup
	$(GOVUK_DOCKER) run $@-app-draft bin/rake db:create
	$(GOVUK_DOCKER) run $@-app-draft bin/rails runner 'User.first || User.create'
