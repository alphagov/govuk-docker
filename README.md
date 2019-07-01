** WIP and could receive breaking changes at any time. **

# govuk-docker

GOV.UK development environment using Docker.

![diagram](docs/diagram.png)

## Introduction

The GOV.UK website is a microservice architecture, formed of many apps working together. Developing in this ecosystem is a challenge, due to the range of environments to maintain, both for the app being developed and its dependencies.

The aim of govuk-docker is to make it easy to develop any GOV.UK app. It achieves this by providing a variety of environments or _stacks_ for each app, in which you can run tests, start a debugger,
publish a document end-to-end e.g.

```
# Run whitehall rake plus any required dependencies (DBs)
whitehall$ govuk-docker run-this default rake

# Start content-tagger rails plus a minimal backend stack
content-tagger$ govuk-docker run-this backend

# Start content-publisher rails plus an end-to-end stack
content-publisher$ govuk-docker run-this e2e
```

The above examples make use of an alias to reduce the amount of typing; the full form is `govuk-docker run-this`. In the last two commands, the app will be available in your browser at *app-name.dev.gov.uk*.

## User Needs

The aim of govuk-docker is to meet the following primary need.

> **As a** developer on GOV.UK apps <br/>
> **I want** a GOV.UK environment optimised for development <br/>
> **So that** I can develop GOV.UK apps efficiently

However, this high-level statement hides a great number of specific needs, which also help to clarify the design decisions for govuk-docker. These lower-level [needs](docs/NEEDS.md) and associated [decisions](docs/DECISIONS.md) are set out in separate documents.

## Prerequisites

First make sure the following are installed on your system:

   - [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) to make *app-name.dev.gov.uk* work. You can install this using `brew install dnsmasq`
   - [docker](https://hub.docker.com/) and [docker-compose](https://docs.docker.com/compose/install/), fairly obviously
   - [git](https://git-scm.com) if you're setting everything up from scratch
   - A directory `~/govuk` in your home directory

## Setup

Start with the following in your bash config.

```
export PATH=$PATH:~/govuk/govuk-docker/bin
```

Now in the `govuk` directory, run the following commands.

```
git clone git@github.com:alphagov/govuk-docker.git
cd govuk-docker

# Expect this to take some time (around 20 minutes)
make
```

If you have been using the vagrant based dev vm, take a backup
of  `/etc/resolver/dev.gov.uk`.

```
cp /etc/resolver/dev.gov.uk ~/dev.gov.uk
```

Then create or append to the following and restart dnsmasq. If you've been using
the vagrant based dev vm, you'll need to replace `/etc/resolver/dev.gov.uk`..

```
# /etc/resolver/dev.gov.uk
nameserver 127.0.0.1

# /usr/local/etc/dnsmasq.conf (bottom)
conf-dir=/usr/local/etc/dnsmasq.d,*.conf

# /usr/local/etc/dnsmasq.d/development.conf
address=/dev.gov.uk/127.0.0.1
```

Once you've updated those files, restart dnsmasq:
```
sudo brew services restart dnsmasq
```

To check if the new config has been applied, you can run `scutil --dns` to check that `dev.gov.uk` appears in the list.

To check name resolution run `dig app.dev.gov.uk`. The response has to include answer section

```
;; ANSWER SECTION:
app.dev.gov.uk.		0	IN	A	127.0.0.1
```

## Compatibility

The following apps are supported by govuk-docker to some extent.

   - ⚠ asset-manager
      * One [failing spec](https://github.com/alphagov/asset-manager/blob/master/spec/requests/virus_scanning_spec.rb#L54) for virus scanning
   - ⚠ content-data-admin
      * **TODO: Missing support for a webserver stack**
   - ✅ content-publisher
   - ⚠ content-store
      * [MongoDB config](https://github.com/alphagov/govuk-docker/blob/master/content-store/mongoid.yml#L14) is overriden to use a different test DB
   - ⚠ content-tagger
      * [chromedriver-helper](https://github.com/alphagov/govuk-docker/blob/master/content-tagger/docker-compose.yml#L13) version lock is manually added
   - ⚠ government-frontend
      * [chromedriver-helper](https://github.com/alphagov/govuk-docker/blob/master/content-tagger/docker-compose.yml#L13) version lock is manually added
   - ✅ govspeak
   - ⚠ govuk-developer-docs
      * Some manuals require [explicit UTF-8 support](https://github.com/docker-library/docs/blob/master/ruby/content.md#encoding)
      * [One test](https://github.com/alphagov/govuk-developer-docs/blob/master/spec/app/document_types_spec.rb#L17) fails due to an irrelevant ordering issue
      * [Another test](https://github.com/alphagov/govuk-developer-docs/blob/master/spec/app/document_types_csv_spec.rb) seems to be failing due fixture issues
   - ✅ govuk-lint
   - ✅ govuk_app_config
   - ❌ govuk_publishing_components
      * Unable to run `rake` due to an [old version of Jasmine](https://github.com/jasmine/jasmine-gem/issues/285)
   - ✅ miller-columns-element
   - ✅ plek
   - ✅ publishing-api
   - ❌ router
      * Unable to run `make test` due to a [hardcoded DB host](https://github.com/alphagov/router/blob/master/integration_tests/route_helpers.go#L77)
   - ✅ router-api
   - ✅ signon
   - ⚠ static
      * JavaScript 404 errors when previewing pages, possibly [related to analytics](https://github.com/alphagov/static/blob/master/app/assets/javascripts/analytics/init.js.erb#L28)
   - ✅ support
   - ⚠ support-api
      * [PostgreSQL config](https://github.com/alphagov/govuk-docker/blob/master/support-api/database.yml) is overriden to set a non-localhost URL
   - ⚠ whitehall
      * Who knows, really - several tests are failing, lots pass ;-)
      * Rake task to [create a test taxon](https://github.com/alphagov/whitehall/blob/master/lib/tasks/taxonomy.rake#L11) for publishing is not idempotent
      * Placeholder images don't work as missing proxy for [/government/assets](https://github.com/alphagov/whitehall/blob/master/app/presenters/publishing_api/news_article_presenter.rb#L133)

## FAQs

### How to: diagnose and troubleshoot

Sometimes things go wrong or some investigation is needed. As govuk-docker is just a bunch of docker config and a CLI wrapper, it's still possible to use all the standard docker commands to help fix issues and get more info e.g.

```
# tail logs for running services
govuk-docker logs -f

# get all the running containers
docker ps -a

# get a terminal inside a service
govuk-docker run-this default bash
```

### How to: add a new service

Here's an example commit that does just that.

https://github.com/alphagov/govuk-docker/commit/1cd31a5fa3469cce47637db81f17ca1b03d72f89

### How to: change a service e.g. upgrade Ruby

This will usually involve editing a `Dockerfile`, for things like system packages or new language versions; or a `docker-compose.yml` file, for things like environment variables and dependencies on other services. When a `Dockerfile` changes, the associated image needs to be rebuilt, which can be done in the service directory by running `gdb`.

### How to: setup a specific service

If a new service has been added to govuk-docker, first pull the latest version to get the changes. One way to setup the new service would be to run `make`, but this goes through every service and might take a while. A faster way is to do this:

```
# auto-clone any new services
make clone

# setup the specific service(s)
make -f my_service/Makefile
```

### How to: update everything!

Sometimes it's useful to get all changes for all repos e.g. to support finding things with a govuk-wide grep. This can be done by running `make pull`, followed by `make setup` to ensure all services continue to run as expected.


## Licence

[MIT License](LICENCE)
