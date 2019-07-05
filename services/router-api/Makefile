router-api: $(GOVUK_ROOT_DIR)/$@ router
	govuk-docker compose build $@-lite
	govuk-docker compose run $@-lite bundle
