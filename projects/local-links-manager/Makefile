local-links-manager: bundle-local-links-manager
	$(GOVUK_DOCKER) run --rm $@-lite bin/rake db:prepare
	$(GOVUK_DOCKER) run --rm $@-lite env RAILS_ENV=test bin/rake db:prepare
	$(GOVUK_DOCKER) run --rm $@-lite yarn
