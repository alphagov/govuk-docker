collections-publisher: $(GOVUK_ROOT_DIR)/collections-publisher publishing-api content-store link-checker-api
	$(COMPOSE_RUN) collections-publisher-lite bundle
	$(COMPOSE_RUN) collections-publisher-lite sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
