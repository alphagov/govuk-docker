router: $(GOVUK_ROOT_DIR)/$@
	govuk-docker compose build $@-lite
	govuk-docker compose run $@-lite sh -c "BINARY=router make build"
