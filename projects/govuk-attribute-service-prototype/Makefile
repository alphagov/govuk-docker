govuk-attribute-service-prototype: bundle-govuk-attribute-service-prototype
	$(GOVUK_DOCKER) run $@-lite bin/rails db:setup
	$(GOVUK_DOCKER) run $@-lite env RAILS_ENV=test bin/rake db:setup
