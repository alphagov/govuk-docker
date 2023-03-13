publishing-api: bundle-publishing-api
	$(GOVUK_DOCKER) run $@-lite bin/rake db:prepare
	$(GOVUK_DOCKER) run $@-lite env RAILS_ENV=test bin/rake db:prepare
	$(GOVUK_DOCKER) run $@-lite bin/rails runner 'User.first || User.create'
	$(GOVUK_DOCKER) run $@-lite bin/rake setup_exchange
