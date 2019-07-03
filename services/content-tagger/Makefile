content-tagger: $(GOVUK_ROOT_DIR)/content-tagger publishing-api
	$(COMPOSE_RUN) content-tagger-lite bundle
	$(COMPOSE_RUN) content-tagger-lite sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
