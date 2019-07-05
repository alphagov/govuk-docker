content-store: $(GOVUK_ROOT_DIR)/$@ router-api govuk-content-schemas
	govuk-docker compose build $@-lite
	govuk-docker compose run $@-lite bundle
	govuk-docker compose run $@-lite bin/rake db:create
	govuk-docker compose run $@-lite bin/rails runner 'User.first || User.create'
	govuk-docker compose run $@-app-draft bin/rake db:create
	govuk-docker compose run $@-app-draft bin/rails runner 'User.first || User.create'
