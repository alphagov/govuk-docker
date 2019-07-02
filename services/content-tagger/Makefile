content-tagger: $(GOVUK_ROOT_DIR)/content-tagger publishing-api
	$(COMPOSE_RUN) content-tagger-default bundle
	$(COMPOSE_RUN) content-tagger-default sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
