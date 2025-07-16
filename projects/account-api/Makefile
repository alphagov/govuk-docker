account-api: bundle-account-api content-store
	$(GOVUK_DOCKER) run --rm $@-lite bin/rails db:prepare
	$(GOVUK_DOCKER) run --rm $@-lite env RAILS_ENV=test bin/rails db:prepare
