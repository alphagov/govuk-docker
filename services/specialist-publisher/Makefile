specialist-publisher: ../specialist-publisher asset-manager publishing-api
	bin/govuk-docker compose run specialist-publisher-default bundle
	bin/govuk-docker compose run specialist-publisher-default sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
