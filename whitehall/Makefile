whitehall: ../whitehall asset-manager publishing-api static
	govuk-docker run whitehall-default bundle
	govuk-docker run whitehall-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
	govuk-docker run whitehall-default rake shared_mustache:compile
	govuk-docker run whitehall-e2e rake taxonomy:populate_end_to_end_test_data
