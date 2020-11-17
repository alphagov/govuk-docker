whitehall: bundle-whitehall asset-manager publishing-api static
	$(GOVUK_DOCKER) run $@-lite sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
	$(GOVUK_DOCKER) run $@-lite yarn
	$(GOVUK_DOCKER) run $@-lite bin/rake shared_mustache:compile
