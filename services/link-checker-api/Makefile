link-checker-api: bundle-link-checker-api
	$(GOVUK_DOCKER) compose run $@-lite sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
