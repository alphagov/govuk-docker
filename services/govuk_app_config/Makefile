govuk_app_config: $(GOVUK_ROOT_DIR)/govuk_app_config
	$(COMPOSE_RUN) govuk_app_config-lite install -s && gem install --conservative bundler
	$(COMPOSE_RUN) govuk_app_config-lite bundle
