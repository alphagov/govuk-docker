authenticating-proxy: bundle-authenticating-proxy router
	$(GOVUK_DOCKER) compose run $@-lite bin/rails runner 'User.first || User.create'
