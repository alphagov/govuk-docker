publishing-api: bundle-publishing-api
	$(GOVUK_DOCKER) run --rm $@-lite bin/rake db:prepare
	$(GOVUK_DOCKER) run --rm $@-lite env RAILS_ENV=test bin/rake db:prepare
	$(GOVUK_DOCKER) run --rm $@-lite bin/rails runner 'User.first || User.create'
	$(GOVUK_DOCKER) run --rm $@-lite bin/rake setup_exchange
