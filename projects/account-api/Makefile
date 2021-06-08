account-api: bundle-account-api content-store govuk-account-manager-prototype
	$(GOVUK_DOCKER) run $@-lite bin/rails db:prepare
	$(GOVUK_DOCKER) run $@-lite env RAILS_ENV=test bin/rails db:prepare
