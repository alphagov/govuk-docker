account-api: bundle-account-api
	$(GOVUK_DOCKER) run $@-lite bin/rails db:setup
	$(GOVUK_DOCKER) run $@-lite env RAILS_ENV=test bin/rails db:setup
