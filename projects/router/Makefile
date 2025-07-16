router: clone-router
	$(GOVUK_DOCKER) up -d mongo-3.6
	$(GOVUK_DOCKER) exec mongo-3.6 mongo --eval "rs.initiate({ \
		'_id' : 'mongo-replica-set', \
		'version' : 1, \
		'members' : [ \
			{ \
				'_id' : 0, \
				'host' : 'mongo-3.6:27017' \
			} \
		]\
	}).ok || rs.status().ok"
	$(GOVUK_DOCKER) build $@-lite
	$(GOVUK_DOCKER) run --rm $@-lite make build
