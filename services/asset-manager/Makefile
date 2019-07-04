asset-manager: $(GOVUK_ROOT_DIR)/asset-manager
	$(COMPOSE_RUN) asset-manager-lite rbenv install -s && gem install --conservative bundler
	$(COMPOSE_RUN) asset-manager-lite bundle
	$(COMPOSE_RUN) asset-manager-lite sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
	$(COMPOSE_RUN) asset-manager-lite bin/rails runner 'User.first || User.create'
