content-store: ../content-store router-api govuk-content-schemas
	bin/govuk-docker compose run content-store-default bundle
	bin/govuk-docker compose run content-store-default rake db:create
	bin/govuk-docker compose run content-store-default rails runner 'User.first || User.create'
	bin/govuk-docker compose run content-store-draft rake db:create
	bin/govuk-docker compose run content-store-draft rails runner 'User.first || User.create'
