government-frontend: $(GOVUK_ROOT_DIR)/$@ content-store router static govuk-content-schemas
	govuk-docker compose build $@-lite
	govuk-docker compose run $@-lite bundle
