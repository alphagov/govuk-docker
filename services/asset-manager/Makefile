asset-manager: ../asset-manager
	bin/govuk-docker compose run asset-manager-default bundle
	bin/govuk-docker compose run asset-manager-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
	bin/govuk-docker compose run asset-manager-default rails runner 'User.first || User.create'
