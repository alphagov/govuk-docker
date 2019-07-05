government-frontend: $(GOVUK_ROOT_DIR)/$@ content-store router static govuk-content-schemas
	$(GOVUK_DOCKER) compose build $@-lite
	$(GOVUK_DOCKER) compose run $@-lite bundle
