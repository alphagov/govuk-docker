content-data-admin: bundle-content-data-admin
	$(GOVUK_DOCKER) compose run $@-lite sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
