# Compatibility

The following lists indicates the support status of a repo in GOV.UK Docker.

- ✅ - can successfully run tests; can successfully start and interact with the app (if applicable).
- ⚠  - partially supported; the comments should explain what does/not work.
- ❌ - not supported; it should be possible to add support, unless the comments say otherwise.

## Executable "apps"

These are repos that can be started as a some kind of process, such as a web app or worker.

   - ✅ account-api
   - ✅ asset-manager
   - ✅ authenticating-proxy
   - ✅ bouncer
   - ❌ ckan
      * Has a [separate](https://github.com/alphagov/docker-ckan) Docker project.
   - ✅  collections
   - ✅ collections-publisher
   - ✅ contacts-admin
   - ✅ content-data-admin
   - ✅ content-data-api
   - ✅ content-publisher
   - ✅ content-store
   - ✅ content-tagger
   - ⚠ datagovuk_find
      * **TODO: Missing support for a webserver stack**
   - ⚠ datagovuk_publish
      * **TODO: Missing support for a webserver stack**
   - ✅ email-alert-api
   - ✅ email-alert-frontend
   - ✅ email-alert-service
   - ✅ feedback
   - ✅ finder-frontend
   - ✅ frontend
   - ✅ government-frontend
   - ✅ govspeak-preview
   - ⚠ govuk_crawler_worker
      * **TODO: Missing support for running the worker**
   - ✅ govuk_publishing_components
   - ✅ govuk-developer-docs
   - ✅ hmrc-manuals-api
   - ✅ imminence
   - ✅ info-frontend
   - ✅ licence-finder
   - ❌ licensify
      * Has a [separate](https://github.com/alphagov/licensify/blob/master/DOCKER.md) Docker project.
   - ✅ link-checker-api
   - ✅ local-links-manager
   - ✅ locations-api
   - ✅ manuals-publisher
   - ✅ maslow
   - ✅ publisher
   - ✅ publishing-api
   - ✅ release
   - ✅ router
   - ✅ router-api
   - ✅ search-admin
   - ✅ search-api
   - ✅ service-manual-publisher
   - ✅ short-url-manager
   - ❌ sidekiq-monitoring
   - ✅ signon
   - ✅ smart-answers
   - ✅ special-route-publisher
   - ✅ specialist-publisher
   - ✅ static
   - ✅ support
   - ✅ support-api
   - ✅ transition
   - ✅ travel-advice-publisher
   - ✅ whitehall

## Generic Ruby libraries

These repos are used as part of running the live GOV.UK site. Since all of them have the same config and "lite" stack, they are bundled together in a single "generic-ruby-library" project.

   - ✅ gds-api-adapters
   - ❌ gds-sso
   - ✅ govspeak
   - ✅ govuk_app_config
   - ❌ govuk_document_types
   - ❌ govuk_message_queue_consumer
   - ❌ govuk_schemas
   - ❌ govuk_sidekiq
   - ❌ govuk_taxonomy_helpers
   - ✅ plek
   - ❌ slimmer
   - ✅ smokey
   - ❌ transition-config
