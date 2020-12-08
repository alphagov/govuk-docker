contacts-admin: bundle-contacts-admin
	$(GOVUK_DOCKER) run $@-lite sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
	$(GOVUK_DOCKER) run $@-lite yarn
