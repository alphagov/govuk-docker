content-store: ../content-store router-api
	bin/govuk-docker run content-store-default bundle
	bin/govuk-docker run content-store-default rake db:create
	bin/govuk-docker run content-store-default rails runner 'User.first || User.create'
