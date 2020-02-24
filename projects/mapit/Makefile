mapit:
	- $(GOVUK_DOCKER) run $@-app createuser -U postgres mapit
	- $(GOVUK_DOCKER) run $@-app createdb -U postgres --owner mapit mapit
	- $(GOVUK_DOCKER) run $@-app psql -U postgres -c "CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology;" mapit
	- $(GOVUK_DOCKER) run $@-app python ./manage.py migrate -v 0
