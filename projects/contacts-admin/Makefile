contacts-admin: bundle-contacts-admin collections static whitehall
	$(GOVUK_DOCKER) run $@-lite sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
