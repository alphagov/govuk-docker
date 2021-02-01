whitehall: bundle-whitehall asset-manager publishing-api static
	$(GOVUK_DOCKER) run $@-lite bin/rake db:setup
	$(GOVUK_DOCKER) run $@-lite env RAILS_ENV=test bin/rake db:setup
	$(GOVUK_DOCKER) run $@-lite yarn
	$(GOVUK_DOCKER) run $@-lite bin/rake shared_mustache:compile
