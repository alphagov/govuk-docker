router: clone-router
	$(GOVUK_DOCKER) up -d mongo-2.6
	$(GOVUK_DOCKER) exec mongo-2.6 mongo --eval "rs.initiate()"
	$(GOVUK_DOCKER) run $@-lite make build
