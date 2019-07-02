travel-advice-publisher: ../travel-advice-publisher asset-manager content-store publishing-api
	bin/govuk-docker compose run travel-advice-publisher-default bundle
	bin/govuk-docker compose run travel-advice-publisher-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
