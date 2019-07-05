support: $(GOVUK_ROOT_DIR)/$@ support-api
	$(GOVUK_DOCKER) compose build $@-lite
	$(GOVUK_DOCKER) compose run $@-lite bundle
