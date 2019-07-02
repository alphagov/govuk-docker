content-data-admin: ../content-data-admin
	bin/govuk-docker run content-data-admin-default bundle
	bin/govuk-docker run content-data-admin-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
