# GOV.UK Docker

GOV.UK development environment using Docker.

![diagram](docs/diagram.png)

The GOV.UK website uses a microservice architecture. Developing in this ecosystem is a challenge, due to the range of environments to maintain, both for the app being developed and its dependencies.

The aim of govuk-docker is to make it easy to develop any GOV.UK app. It achieves this by providing a variety of environments or _stacks_ for each app, in which you can run tests, start a debugger, publish a document end-to-end.

## Background

[RFC 106: Use Docker for local development](https://github.com/alphagov/govuk-rfcs/blob/master/rfc-106-docker-for-local-development.md) describes the background for choosing Docker.

To guide development we [have documented the user needs](docs/NEEDS.md) and [associated decisions](docs/DECISIONS.md) in this repo.

## Usage

Do this to run the tests for a service:

```sh
cd ~/govuk/collections-publisher

# You only need to do this once per service
govuk-docker build

govuk-docker run bundle exec rake
```

Do this to start a GOV.UK web app:

```sh
cd ~/govuk/collections-publisher

# You only need to do this once per service
govuk-docker build

# Start collections-publisher including dependencies.
# Visit it at collections-publisher.dev.gov.uk
govuk-docker startup
```

govuk-docker knows which application we're running based on the name of the current directory, matching it with the corresponding [docker-compose.yml](https://github.com/alphagov/govuk-docker/blob/master/services/content-tagger/docker-compose.yml) in `govuk-docker/services`.


For a full list of govuk-docker commands, run `govuk-docker help`.

## Installation

### Prerequisites

govuk-docker has the following dependencies:

- [brew](https://brew.sh/). (If you don't use a Mac, you'll need to dig into the `govuk-docker setup` command and manually install the things referenced).
- [git](https://git-scm.com)
- Ruby (whatever version is specified in [.ruby-version](https://github.com/alphagov/govuk-docker/blob/master/.ruby-version))
- A directory `~/govuk` in your home directory

All other dependencies will be installed for you automatically.

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

You can now [clone and setup the apps you need](#Usage), after which you can do things like run tests and startup the app in your browser. If this doesn't work for whatever reason, follow the [instructions to set up Dnsmasq manually](#how-to-set-up-dnsmasq-manually).

### Environment variables

Both govuk-docker and the Makefile respect the following environment variables:

- `$GOVUK_ROOT_DIR` - directory where app repositories live, defaults to `$HOME/govuk`
- `$GOVUK_DOCKER_DIR` - directory where the govuk-docker repository lives, defaults to `$GOVUK_ROOT_DIR/govuk-docker`
- `$GOVUK_DOCKER` - path of the govuk-docker script, defaults to `$GOVUK_DOCKER_DIR/bin/govuk-docker`

## Compatibility

The following apps are supported by govuk-docker to some extent.

   - ✅ asset-manager
   - ⚠ cache-clearing-service
      * Tests pass
      * Queues are not set-up, so cache-clearing-service can't be run locally
   - ⚠ calculators
      * Web UI doesn't work without the content item being present in the content-store.
   - ✅ calendars
   - ⚠  collections
      * You will need to [populate the Content Store database](#mongodb) or run the live stack in order for it to work locally.
      * To view topic pages locally you still need to use the live stack as they rely on Elasticsearch data which we are yet to be able to import.
   - ✅ collections-publisher
   - ⚠ content-data-admin
      * **TODO: Missing support for a webserver stack**
   - ✅ content-publisher
   - ✅ content-store
   - ✅ content-tagger
   - ✅ email-alert-api
   - ✅ email-alert-frontend
   - ✅ finder-frontend
   - ❌ frontend
   - ✅ government-frontend
   - ✅ govspeak
   - ✅ govuk_app_config
   - ✅ govuk_publishing_components
   - ✅ govuk-cdn-config
   - ❓ govuk-content-schemas
      * Service exists in govuk-docker but is untested
   - ✅ govuk-developer-docs
   - ✅ govuk-lint
   - ✅ info-frontend
   - ⚠ link-checker-api
      * Works in isolation but not in other services' `e2e` stacks, so must be run in a separate process.
        See https://github.com/alphagov/govuk-docker/issues/174 for details.
   - ✅ manuals-frontend
   - ✅ miller-columns-element
   - ✅ plek
   - ✅ publisher
   - ✅ publishing-api
   - ✅ router
   - ✅ router-api
   - ✅ search-admin
   - ⚠  search-api
      * Tests fail as they run against [both Elasticsearch instances](https://github.com/alphagov/search-api/pull/1618)
   - ✅ service-manual-frontend
   - ✅ short-url-manager
   - ✅ signon
   - ✅ smart-answers
   - ✅ specialist-publisher
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

`govuk-docker startup` runs the application on the `app` [stack](#stacks) by default, but you can override the stack by passing an unnamed parameter which will be taken as the stack name, with an `app-` prefix. Example:

```sh
cd ~/govuk/content-publisher

# Start content-publisher with an "app-e2e" (end-to-end) stack
govuk-docker startup e2e
```

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
# make sure govuk-docker is up-to-date
git pull

# make sure the service is built OK
govuk-docker build

# tail logs for running services
govuk-docker compose logs -f

# get all the running containers
docker ps -a

# get a terminal inside a service
govuk-docker run bash
```

### How to: update everything!

Sometimes it's useful to get all changes for all repos e.g. to support finding things with a govuk-wide grep. This can be done by running:

```
make pull
```

### How to: set up Dnsmasq manually

If the [installation instructions](#setup) above didn't work for you, you may need to do some things manually as outlined below.

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

Then append the following to the bottom of `/usr/local/etc/dnsmasq.conf`:

```
conf-dir=/usr/local/etc/dnsmasq.d,*.conf
```

Then create or append to `/usr/local/etc/dnsmasq.d/development.conf`:

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

### How to: work with local gems

Provide a local gem path relative to the location of the Gemfile you're editing:

```ruby
gem 'govuk_publishing_components', path: '../govuk_publishing_components' 
```

### How to: replicate data locally

There may be times when a full database is required locally.  The following sections give examples of how to replicate this data from integration.  All examples reqire pv, which can be installed on a Mac using Brew (`brew install pv`).

#### MySQL

1. Download the relevant database dump from the [AWS S3 Bucket](https://s3.console.aws.amazon.com/s3/buckets/govuk-integration-database-backups/mysql/?region=eu-west-1&tab=overview)

2. Drop and recreate any existing database, e.g. for Whitehall:

```
govuk-docker compose up -d mysql
govuk-docker compose run mysql mysql -h mysql -u root --password=root -e "DROP DATABASE IF EXISTS whitehall_development"
govuk-docker compose run mysql mysql -h mysql -u root --password=root -e "CREATE DATABASE whitehall_development"
```

3. Import the file into the local MySQL database, e.g. for Whitehall:

```
pv whitehall_production.dump.gz | gunzip | govuk-docker compose run mysql mysql -h mysql -u root --password=root whitehall_development
```

#### PostgreSQL

1. Download the relevant database dump from the [AWS S3 Bucket](https://s3.console.aws.amazon.com/s3/buckets/govuk-integration-database-backups/postgres/?region=eu-west-1&tab=overview)

2. Drop and recreate any existing database, e.g. for Publishing API:

```
govuk-docker compose up -d postgres
govuk-docker compose run postgres /usr/bin/psql -h postgres -U postgres -qAt DROP DATABASE IF EXISTS "publishing-api"
govuk-docker compose run postgres /usr/bin/createdb -h postgres -U postgres publishing-api
```

3. Import the file into the local Postgres database, e.g. for Publishing API:

```
pv publishing_api_production.dump.gz  | gunzip | govuk-docker compose run postgres /usr/bin/psql -h postgres -U postgres -qAt -d publishing-api
```

#### MongoDB

1.  Download the relevant database dump from the [AWS S3 Bucket](https://s3.console.aws.amazon.com/s3/object/govuk-integration-database-backups/mongodb/daily/mongo/?region=eu-west-1&tab=overview)

2. Unzip the archive, e.g. for Content Store:

```
gunzip mongodump-2019-08-12_0023.tgz
```

Or if it's a TAR file, you can extract a specific file or directory.  Using the Content Store as an example:
```
tar -xvzf mongodump-2019-08-12_0023.tar var/lib/mongodb/backup/mongodump/content_store_production -C directory_for_download
```

3. Update the `docker-compose.yml` file to mount your local directory into the VM, e.g.

```
  mongo:
    image: mongo:2.4
    volumes:
      - mongo:/data/db
      - /Path/To/Downloads/directory_for_download:/import
    ports:
      - "27017:27017"
      - "27018:27018"
```

4. Import the backup files into the local Mongo database, e.g. for Content Store:

```
govuk-docker compose up -d mongo
govuk-docker compose run mongo mongorestore --drop --db content-store /import/var/lib/mongodb/backup/mongodump/content_store_production/
```

## Licence

[MIT License](LICENCE)
