whitehall: ../whitehall asset-manager publishing-api static
	bin/govuk-docker compose run whitehall-default bundle
	bin/govuk-docker compose run whitehall-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
	bin/govuk-docker compose run whitehall-default rake shared_mustache:compile
	bin/govuk-docker compose run whitehall-e2e rake taxonomy:populate_end_to_end_test_data
