link-checker-api: ../link-checker-api
	bin/govuk-docker compose run link-checker-api-default bundle
	bin/govuk-docker compose run link-checker-api-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
