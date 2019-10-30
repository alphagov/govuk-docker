govuk-content-schemas: bundle-govuk-content-schemas
	$(GOVUK_DOCKER) run $@-lite rbenv install -s
	$(GOVUK_DOCKER) run $@-lite gem install --conservative bundler -v "~>1.0"
	$(GOVUK_DOCKER) run $@-lite bundle
