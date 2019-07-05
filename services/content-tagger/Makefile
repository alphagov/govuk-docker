content-tagger: $(GOVUK_ROOT_DIR)/$@ publishing-api
	govuk-docker compose build $@-lite
	govuk-docker compose run $@-lite bundle
	govuk-docker compose run $@-lite sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
