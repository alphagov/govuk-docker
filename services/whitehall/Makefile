whitehall: bundle-whitehall asset-manager publishing-api static frontend
	$(GOVUK_DOCKER) compose run $@-lite sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
	$(GOVUK_DOCKER) compose run $@-lite bin/rake shared_mustache:compile
	$(GOVUK_DOCKER) compose run $@-app-e2e bin/rake taxonomy:populate_end_to_end_test_data
