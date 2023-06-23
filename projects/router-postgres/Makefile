router-postgres: clone-router-postgres
	$(GOVUK_DOCKER) up -d postgres-14
	$(GOVUK_DOCKER) run $@-lite make build
	
