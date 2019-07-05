publishing-api: $(GOVUK_ROOT_DIR)/$@ content-store govuk-content-schemas
	$(GOVUK_DOCKER) compose build $@-lite
	$(GOVUK_DOCKER) compose run $@-lite bundle
	$(GOVUK_DOCKER) compose run $@-lite sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
	$(GOVUK_DOCKER) compose run $@-lite bin/rails runner 'User.first || User.create'
	$(GOVUK_DOCKER) compose run $@-lite bin/rake setup_exchange
