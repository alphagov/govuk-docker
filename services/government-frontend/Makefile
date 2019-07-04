government-frontend: $(GOVUK_ROOT_DIR)/government-frontend content-store router static govuk-content-schemas
	$(COMPOSE_RUN) government-frontend-lite rbenv install -s && gem install --conservative bundler
	$(COMPOSE_RUN) government-frontend-lite bundle
