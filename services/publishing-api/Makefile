publishing-api: ../publishing-api content-store govuk-content-schemas
	bin/govuk-docker compose run publishing-api-default bundle
	bin/govuk-docker compose run publishing-api-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
	bin/govuk-docker compose run publishing-api-default rails runner 'User.first || User.create'
	bin/govuk-docker compose run publishing-api-default rake setup_exchange
