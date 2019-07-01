content-publisher_setup: asset-manager_setup publishing-api_setup
	govuk-docker run content-publisher-default bundle
	govuk-docker run content-publisher-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
	govuk-docker run content-publisher-default yarn
