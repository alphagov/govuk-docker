signon: $(GOVUK_ROOT_DIR)/signon
	$(COMPOSE_RUN) signon-default bundle
	$(COMPOSE_RUN) signon-default sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
