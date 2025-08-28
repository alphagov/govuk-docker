content-block-manager: bundle-content-block-manager publishing-api signon
	$(GOVUK_DOCKER) run $@-lite bin/rake db:prepare
	$(GOVUK_DOCKER) run $@-lite env RAILS_ENV=test bin/rake db:prepare
	$(GOVUK_DOCKER) run $@-lite yarn
	$(GOVUK_DOCKER) run $@-lite yarn playwright install --with-deps
