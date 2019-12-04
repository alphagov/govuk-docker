support-api: bundle-support-api
	$(GOVUK_DOCKER) run $@-lite sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
