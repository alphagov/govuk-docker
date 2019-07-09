signon: bundle-signon
	$(GOVUK_DOCKER) compose run $@-lite sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
