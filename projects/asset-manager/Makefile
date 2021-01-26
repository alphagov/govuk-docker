asset-manager: bundle-asset-manager
	$(GOVUK_DOCKER) run $@-lite bin/rake db:setup
	$(GOVUK_DOCKER) run $@-lite bin/rails runner 'User.first || User.create'
