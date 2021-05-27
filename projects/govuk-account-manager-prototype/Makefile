govuk-account-manager-prototype: bundle-govuk-account-manager-prototype govuk-attribute-service-prototype
	$(GOVUK_DOCKER) run $@-lite bin/rails db:prepare
	$(GOVUK_DOCKER) run $@-lite env RAILS_ENV=test bin/rake db:prepare
