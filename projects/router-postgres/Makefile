router-postgres: clone-router-postgres
	$(GOVUK_DOCKER) pull postgres-14
	$(GOVUK_DOCKER) run --rm -d postgres-14
	$(GOVUK_DOCKER) run $@-lite make build
