maslow: bundle-maslow publishing-api
	$(GOVUK_DOCKER) run --rm $@-lite bin/rake db:setup
	$(GOVUK_DOCKER) run --rm $@-lite bin/rails runner 'User.first || User.create'
	$(GOVUK_DOCKER) run --rm $@-lite yarn
