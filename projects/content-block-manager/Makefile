content-block-manager: bundle-content-block-manager publishing-api signon frontend whitehall publisher
	$(GOVUK_DOCKER_RUN) $@-lite bin/rake db:prepare
	$(GOVUK_DOCKER_RUN) $@-lite env RAILS_ENV=test bin/rake db:prepare
	$(GOVUK_DOCKER_RUN) $@-lite yarn
	$(GOVUK_DOCKER_RUN) $@-lite yarn playwright install --with-deps
