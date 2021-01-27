# Compatibility

The following lists indicates the support status of a repo in GOV.UK Docker.

- ✅ - can successfully run tests; can successfully start and interact with the app (if applicable).
- ⚠  - partially supported; the comments should explain what does/not work.
- ❌ - not supported; it should be possible to add support, unless the comments say otherwise.

## Executable "apps"

These are repos that can be started as a some kind of process, such as a web app or worker.

   - ✅ asset-manager
   - ⚠ bouncer
      * **TODO: Missing support for a webserver stack**
   - ✅ cache-clearing-service
   - ⚠ calculators
      * Web UI doesn't work without the content item being present in the content-store.
   - ❌ ckan
      * Has a [separate](https://github.com/alphagov/docker-ckan) Docker project.
   - ⚠  collections
      * You will need to [populate the Content Store database](#mongodb) or run the live stack in order for it to work locally.
      * To view topic pages locally you still need to use the live stack as they rely on Elasticsearch data which we are yet to be able to import.
   - ✅ collections-publisher
   - ⚠ contacts-admin
      * **TODO: Missing support for a webserver stack**
   - ⚠ content-data-admin
      * **TODO: Missing support for a webserver stack**
   - ⚠ content-data-api
      * **TODO: Missing support for a webserver stack**
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
   - ⚠ govuk_crawler_worker
      * **TODO: Missing support for running the worker**
   - ✅ govuk_publishing_components
   - ✅ govuk-developer-docs
   - ⚠ hmrc-manuals-api
      * **TODO: Missing support for a webserver stack**
   - ⚠ imminence
      * **TODO: Missing support for a webserver stack**
   - ✅ info-frontend
   - ✅ licence-finder
   - ❌ licensify
      * Has a [separate](https://github.com/alphagov/licensify/blob/master/DOCKER.md) Docker project.
   - ✅ link-checker-api
   - ✅ local-links-manager
   - ✅ manuals-frontend
   - ⚠ manuals-publisher
      * **TODO: Missing support for a webserver stack**
   - ✅ mapit
      * **TODO: Data replication**
   - ✅ maslow
   - ✅ publisher
   - ✅ publishing-api
   - ✅ release
   - ✅ router
   - ✅ router-api
   - ✅ search-admin
   - ✅ search-api
   - ✅ service-manual-frontend
   - ⚠ service-manual-publisher
      * **TODO: Missing support for a webserver stack**
   - ✅ short-url-manager
   - ❌ sidekiq-monitoring
   - ✅ signon
   - ✅ smart-answers
   - ✅ special-route-publisher
   - ✅ specialist-publisher
   - ⚠ static
      * JavaScript 404 errors when previewing pages, possibly [related to analytics](https://github.com/alphagov/static/blob/master/app/assets/javascripts/analytics/init.js.erb#L28)
   - ✅ support
   - ✅ support-api
   - ✅ transition
   - ❌ transition-config
   - ✅ travel-advice-publisher
   - ⚠ whitehall
      * Who knows, really - several tests are failing, lots pass ;-)
      * Rake task to [create a test taxon](https://github.com/alphagov/whitehall/blob/master/lib/tasks/taxonomy.rake#L11) for publishing is not idempotent
      * Placeholder images don't work as missing proxy for [/government/assets](https://github.com/alphagov/whitehall/blob/master/app/presenters/publishing_api/news_article_presenter.rb#L133)
   - ⚠ govuk-attribute-service-prototype
      * **No support for a webserver stack**
   - ⚠ govuk-account-manager-prototype
      * **No support for a webserver stack**

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
   - ✅ govuk-content-schemas
   - ✅ plek
   - ❌ slimmer
