router-api: $(GOVUK_ROOT_DIR)/router-api router
	$(COMPOSE_RUN) router-api-lite install -s && gem install --conservative bundler
	$(COMPOSE_RUN) router-api-lite bundle
