# GOV.UK Docker

GOV.UK development environment using Docker.

![diagram](docs/diagram.png)

The GOV.UK website uses a microservice architecture. Developing in this ecosystem is a challenge, due to the range of environments to maintain, both for the app being developed and its dependencies.

The aim of govuk-docker is to make it easy to develop any GOV.UK app. It achieves this by providing a variety of environments or _stacks_ for each app, in which you can run tests, start a debugger, publish a document end-to-end.

## Background

[RFC 106: Use Docker for local development](https://github.com/alphagov/govuk-rfcs/blob/master/rfc-106-docker-for-local-development.md) describes the background for choosing Docker.

To guide development we [have documented the user needs](docs/NEEDS.md) and [associated decisions](docs/DECISIONS.md) in this repo.

## Usage

```sh
# Run a Rake task on Whitehall
whitehall$ govuk-docker run bundle exec rake -T

# Start content-tagger including dependencies. Visit it at content-tagger.dev.gov.uk
content-tagger$ govuk-docker startup

# Start content-publisher plus an "end-to-end" stack
content-publisher$ govuk-docker startup e2e
```

## Installation

### Prerequisites

First make sure the following are installed on your system:

- [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) to make *$app-name.dev.gov.uk* work. You can install this using `brew install dnsmasq`.
- [docker](https://hub.docker.com/) and [docker-compose](https://docs.docker.com/compose/install/)
- [git](https://git-scm.com) if you're setting everything up from scratch
- A directory `~/govuk` in your home directory

### Setup

Start with the following in your bash config.

```
export PATH=$PATH:~/govuk/govuk-docker/bin
```

Now in the `~/govuk` directory, run the following commands.

```
git clone git@github.com:alphagov/govuk-docker.git
cd govuk-docker
bundle install
govuk-docker setup
```

You can now clone and setup the apps you need:

```
govuk-docker build --service content-publisher
```

To test it out:

```
govuk-docker startup --service content-publisher
```

If this doesn't work for whatever reason, follow the [instructions to set up Dnsmasq manually](#how-to-set-up-dnsmasq-manually).

### Environment variables

Both govuk-docker and the Makefile respect the following environment variables:

- `$GOVUK_ROOT_DIR` - directory where app repositories live, defaults to `$HOME/govuk`
- `$GOVUK_DOCKER_DIR` - directory where the govuk-docker repository lives, defaults to `$GOVUK_ROOT_DIR/govuk-docker`
- `$GOVUK_DOCKER` - path of the govuk-docker script, defaults to `$GOVUK_DOCKER_DIR/bin/govuk-docker`

## Compatibility

The following apps are supported by govuk-docker to some extent.

   - ✅ asset-manager
   - ✅ calendars
   - ⚠ calculators
      * Web UI doesn't work without the content item being present in the content-store.
   - ✅ collections-publisher
   - ⚠ content-data-admin
      * **TODO: Missing support for a webserver stack**
   - ✅ content-publisher
   - ✅ content-store
   - ✅ content-tagger
   - ⚠  collections
    * Only works with live data
   - ✅ email-alert-api
   - ✅ email-alert-frontend
   - ✅ finder-frontend
   - ❌ frontend
   - ✅ government-frontend
   - ✅ govspeak
   - ✅ govuk-developer-docs
   - ✅ govuk-lint
   - ✅ govuk_app_config
   - ✅ govuk_publishing_components
   - ✅ info-frontend
   - ✅ manuals-frontend
   - ✅ miller-columns-element
   - ✅ plek
   - ✅ publisher
   - ✅ publishing-api
   - ✅ router
   - ✅ router-api
   - ⚠  search-api
    * Tests fail as they run against [both Elasticsearch instances](https://github.com/alphagov/search-api/pull/1618)
   - ✅ search-admin
   - ✅ signon
   - ✅ smart-answers
   - ✅ specialist-publisher
   - ✅ service-manual-frontend
   - ⚠ static
      * JavaScript 404 errors when previewing pages, possibly [related to analytics](https://github.com/alphagov/static/blob/master/app/assets/javascripts/analytics/init.js.erb#L28)
   - ✅ support
   - ✅ support-api
   - ✅ travel-advice-publisher
   - ⚠ whitehall
      * Who knows, really - several tests are failing, lots pass ;-)
      * Rake task to [create a test taxon](https://github.com/alphagov/whitehall/blob/master/lib/tasks/taxonomy.rake#L11) for publishing is not idempotent
      * Placeholder images don't work as missing proxy for [/government/assets](https://github.com/alphagov/whitehall/blob/master/app/presenters/publishing_api/news_article_presenter.rb#L133)

## Stacks

Each service provides a number of different 'stacks' which you can use to run
the app. To provide consistency we have a convention for these names:

- **lite**: This stack provides only the minimum number of dependencies to run
  the application code. This is useful for running the tests, or a Rails
  console, for example. It won't be useful for opening the app in a browser.
- **app**: This stack provides the dependencies necessary to run the app in the
  browser. Variations on this are allowed where necessary such as:
  - **app-draft**: if the application uses the content-store, this stack will
    point to the [draft content-store](https://docs.publishing.service.gov.uk/manual/content-preview.html).
  - **app-live**: if the app is a read-only frontend app, the live stack will
    point the production versions of content-store and search-api.
  - **app-e2e**: to run the app with all the other apps necessary to provide
    full end to end user journeys.

## How to's

### How to: troubleshoot your installation

The `doctor` command will attempt to ensure your installation is in a runnable
state and suggest remedial steps if it finds anything wrong

```
govuk-docker doctor
```

This will test whether or not your system meets the following requirements:

* dnsmasq installed and running
* docker installed
* docker-compose installed

### How to: diagnose and troubleshoot

Sometimes things go wrong or some investigation is needed. As govuk-docker is just a bunch of docker config and a CLI wrapper, it's still possible to use all the standard docker commands to help fix issues and get more info e.g.

```
# tail logs for running services
govuk-docker compose logs -f

# get all the running containers
docker ps -a

# get a terminal inside a service
govuk-docker run bash
```

### How to: add a new service

Here's an example commit that does just that.

https://github.com/alphagov/govuk-docker/commit/1cd31a5fa3469cce47637db81f17ca1b03d72f89

### How to: change a service e.g. upgrade Ruby

This will usually involve editing a `Dockerfile`, for things like system packages or new language versions; or a `docker-compose.yml` file, for things like environment variables and dependencies on other services. When a `Dockerfile` changes, the associated image needs to be rebuilt, which can be done in the service directory by running `gdb`.

### How to: setup a specific service

If a new service has been added to govuk-docker, first pull the latest version to get the changes. Then use `make app-name` to clone (if necessary) and set up just that app and its dependencies.

For example:

```
make content-publisher
```

### How to: update everything!

Sometimes it's useful to get all changes for all repos e.g. to support finding things with a govuk-wide grep. This can be done by running:

```
make pull
```

### How to: set up Dnsmasq manually

If you have been using the vagrant based dev vm, take a backup
of  `/etc/resolver/dev.gov.uk`.

```
cp /etc/resolver/dev.gov.uk ~/dev.gov.uk
```

Then create or update `/etc/resolver/dev.gov.uk`. If you've been using the vagrant based dev VM, you'll need to replace `/etc/resolver/dev.gov.uk`

```
nameserver 127.0.0.1
```
To check if the new config has been applied, you can run `scutil --dns` to check that `dev.gov.uk` appears in the list.

Then append the following to the bottom of `/usr/local/etc/dnsmasq.conf`
```
conf-dir=/usr/local/etc/dnsmasq.d,*.conf
```

Then create or append to `/usr/local/etc/dnsmasq.d/development.conf`
```
address=/dev.gov.uk/127.0.0.1
```

Once you've updated those files, restart dnsmasq:
```
sudo brew services restart dnsmasq
```

To check whether dnsmasq name server at 127.0.0.1 can resolve subdomains of dev.gov.uk run `dig app.dev.gov.uk @127.0.0.1`. The response has to include the following answer section:

```
;; ANSWER SECTION:
app.dev.gov.uk.		0	IN	A	127.0.0.1
```

## Licence

[MIT License](LICENCE)
