calendars: $(GOVUK_ROOT_DIR)/$@
	$(GOVUK_DOCKER) compose build $@-lite
	$(GOVUK_DOCKER) compose run $@-lite bundle
	$(GOVUK_DOCKER) compose run $@-setup bin/rake publishing_api:publish
