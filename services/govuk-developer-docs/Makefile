govuk-developer-docs: $(GOVUK_ROOT_DIR)/govuk-developer-docs
	$(COMPOSE_RUN) govuk-developer-docs-lite rbenv install -s && gem install --conservative bundler
	$(COMPOSE_RUN) govuk-developer-docs-lite bundle
