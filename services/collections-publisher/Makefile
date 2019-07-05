collections-publisher: $(GOVUK_ROOT_DIR)/$@ publishing-api content-store link-checker-api
	govuk-docker compose build $@-lite
	govuk-docker compose run $@-lite bundle
	govuk-docker compose run $@-lite sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
