mapit: 
	- $(GOVUK_DOCKER) run $@ sh -c 'createuser -U postgres mapit'
	- $(GOVUK_DOCKER) run $@ sh -c 'createdb -U postgres --owner mapit mapit'
	- $(GOVUK_DOCKER) run $@ sh -c 'psql -U postgres -c "CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology;" mapit'
	- $(GOVUK_DOCKER) run $@ sh -c 'bash -c "python ./manage.py migrate -v 0"'
