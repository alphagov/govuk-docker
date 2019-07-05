whitehall: $(GOVUK_ROOT_DIR)/$@ asset-manager publishing-api static
	govuk-docker compose build $@-lite
	govuk-docker compose run $@-lite bundle
	govuk-docker compose run $@-lite sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
	govuk-docker compose run $@-lite bin/rake shared_mustache:compile
	govuk-docker compose run $@-app-e2e bin/rake taxonomy:populate_end_to_end_test_data
