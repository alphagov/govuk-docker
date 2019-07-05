asset-manager: $(GOVUK_ROOT_DIR)/$@
	govuk-docker compose build $@-lite
	govuk-docker compose run $@-lite bundle
	govuk-docker compose run $@-lite sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
	govuk-docker compose run $@-lite bin/rails runner 'User.first || User.create'
