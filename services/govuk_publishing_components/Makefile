govuk_publishing_components: $(GOVUK_ROOT_DIR)/$@
	$(GOVUK_DOCKER) compose build $@-lite
	$(GOVUK_DOCKER) compose run $@-lite bundle
