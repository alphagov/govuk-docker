content-data-admin: $(GOVUK_ROOT_DIR)/content-data-admin
	$(COMPOSE_RUN) content-data-admin-lite rbenv install -s && gem install --conservative bundler
	$(COMPOSE_RUN) content-data-admin-lite bundle
	$(COMPOSE_RUN) content-data-admin-lite sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
