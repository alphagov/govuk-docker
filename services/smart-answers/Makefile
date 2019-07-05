smart-answers: $(GOVUK_ROOT_DIR)/$@ asset-manager publishing-api static
	$(GOVUK_DOCKER) compose build $@-lite
	$(GOVUK_DOCKER) compose run $@-lite bundle
