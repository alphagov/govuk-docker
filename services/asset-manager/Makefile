asset-manager: bundle-asset-manager
	$(GOVUK_DOCKER) compose run $@-lite sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
	$(GOVUK_DOCKER) compose run $@-lite bin/rails runner 'User.first || User.create'
