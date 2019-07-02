content-publisher: ../content-publisher asset-manager publishing-api
	bin/govuk-docker run content-publisher-default bundle
	bin/govuk-docker run content-publisher-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
	bin/govuk-docker run content-publisher-default yarn
