router: $(GOVUK_ROOT_DIR)/router
	$(GOVUK_DOCKER) compose build $@-lite
	$(GOVUK_DOCKER) compose run $@-lite sh -c "BINARY=router make build"
