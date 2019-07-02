asset-manager: ../asset-manager
	bin/govuk-docker run asset-manager-default bundle
	bin/govuk-docker run asset-manager-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
	bin/govuk-docker run asset-manager-default rails runner 'User.first || User.create'
