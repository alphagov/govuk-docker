# GOV.UK Docker

GOV.UK development environment using Docker.

![diagram](docs/diagram.png)

The GOV.UK website uses a microservice architecture. Developing in this ecosystem is a challenge, due to the range of environments to maintain, both for the app being developed and its dependencies.

The aim of govuk-docker is to make it easy to develop any GOV.UK app. It achieves this by providing a variety of environments or _stacks_ for each app, in which you can run tests, start a debugger, publish a document end-to-end.

## Background

[RFC 106: Use Docker for local development](https://github.com/alphagov/govuk-rfcs/blob/master/rfc-106-docker-for-local-development.md) describes the background for choosing Docker.

## Usage

Clone your desired [service](#compatibility) into your `~/govuk` folder, e.g. collections-publisher.

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
  - Follow these [instructions to update Ruby using brew](#how-to-update-ruby)
- A directory `~/govuk` in your home directory

All other dependencies will be installed for you automatically.

#### Docker settings
Running GOV.UK applications can be resource intensive and will easily exceed the default configuration of Docker for Mac. To change settings open the Docker dropdown via the Docker whale icon in the macOS menu bar, and select the preferences option.

In `Advanced` settings you should update CPU and RAM resources. These should be at least:

* 6 CPUs
* 12 GB RAM

In `Disk` you should ensure there is a high amount of disk space to allow replicating GOV.UK data. 64GB should be sufficient for most usages but you may need > 100GB to clone all GOV.UK integration data.

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

You can now [clone and setup the apps you need](#Usage), after which you can do things like run tests and startup the app in your browser. If this doesn't work for whatever reason, follow the [instructions on how to resolve setup issues](#how-to-resolve-setup-issues).

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
   - ✅ search-api
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

### How to: update everything!

Sometimes it's useful to get all changes for all repos e.g. to support finding things with a govuk-wide grep. This can be done by running:

```
make pull
```

### How to: clear your Docker containers

Sometimes a service just doesn't work as expected, and the easiest thing to do is to start over. This command stops and removes all local govuk Docker containers:

```
govuk-docker compose rm -sv
```

You should then be able to `govuk-docker build` your service and have confidence you're not suffering from configuration drift.

### How to: resolve setup issues

The following sections resolve common installation issues.

#### How to: install/update Ruby

Follow the instructions to install [rbenv](https://github.com/rbenv/rbenv#installation) using [brew](https://brew.sh/). 

Then install the correct version of Ruby listed in [.ruby-version](https://github.com/alphagov/govuk-docker/blob/master/.ruby-version) - *note* you need to clone this repository (govuk-docker) into `~/govuk` first!

```
cd ~/govuk/govuk-docker
rbenv install
```

Now, when you are in the `~/govuk/govuk-docker` folder, rbenv will automatically switch to the correct version of Ruby - check this by running `ruby -v`.

#### How to: install bundler

To install [bundler](https://bundler.io/), first find out the required version (in X.Y.Z format) from [Gemfile.lock](https://github.com/alphagov/govuk-docker/blob/master/Gemfile.lock) - it will be listed as:

```
BUNDLED WITH
    X.Y.Z
```

Install the correct version of bundler; you may have to overwrite existing bundle and bundler executable conflicts.

```
gem install bundler:X.Y.Z
```

#### How to: resolve issues caused by an existing docker install 

During `govuk-docker setup`, if you get the following errors when pouring `docker-compose`:

```
Error: The `brew link` step did not complete successfully
The formula built, but is not symlinked into /usr/local
Could not symlink bin/docker-compose
Target /usr/local/bin/docker-compose
already exists. You may want to remove it:
  rm '/usr/local/bin/docker-compose'

To force the link and overwrite all conflicting files:
  brew link --overwrite docker-compose

To list all files that would be deleted:
  brew link --overwrite --dry-run docker-compose

Possible conflicting files are:
/usr/local/bin/docker-compose -> /Applications/Docker.app/Contents/Resources/bin/docker-compose
```

and when pouring `docker`:

```
Error: It seems there is already an App at '/Applications/Docker.app'.
```

Then uninstall your existing docker, and restart the `govuk-docker setup` process to install a new version of docker using brew.

#### How to: resolve `No such file or directory` errors for `dev.gov.uk`

If you get the following error during `govuk-docker setup`:

```
No such file or directory @ rb_sysopen - /etc/resolver/dev.gov.uk (Errno::ENOENT)
```

Create the `resolver` folder in `etc`.

```
sudo mkdir /etc/resolver/
```

Then follow the [instructions to set up Dnsmasq manually](#how-to-set-up-dnsmasq-manually).


#### How to: set up Dnsmasq manually

If the [installation instructions](#setup) above didn't work for you, you may need to do some things manually as outlined below.

If you have been using the vagrant based dev vm, take a backup
of  `/etc/resolver/dev.gov.uk`.

```
cp /etc/resolver/dev.gov.uk ~/dev.gov.uk
```

Then create or update `/etc/resolver/dev.gov.uk`; you can create a copy directly from [dnsmasq.conf](https://github.com/alphagov/govuk-docker/blob/master/config/dnsmasq.conf). If you've been using the vagrant based dev VM, you'll need to replace `/etc/resolver/dev.gov.uk`. 

```
sudo cp ~/govuk/govuk-docker/config/dnsmasq.conf /etc/resolver/dev.gov.uk
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

There may be times when a full database is required locally.  The following sections give examples of how to replicate this data from integration.  All examples require pv, which can be installed on a Mac using Brew (`brew install pv`).

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
govuk-docker compose run postgres /usr/bin/psql -h postgres -U postgres -c DROP DATABASE IF EXISTS "publishing-api"
govuk-docker compose run postgres /usr/bin/createdb -h postgres -U postgres publishing-api
```

3. Import the file into the local Postgres database, e.g. for Publishing API:

```
pv publishing_api_production.dump.gz  | gunzip | govuk-docker compose run postgres /usr/bin/psql -h postgres -U postgres -qAt -d publishing-api
```

#### MongoDB

1.  Download the relevant database dump from the [AWS S3 Bucket](https://s3.console.aws.amazon.com/s3/buckets/govuk-integration-database-backups/mongodb/daily/mongo/?region=eu-west-1&tab=overview)

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

### How to: set environment variables

While most environment variables should be set in the config for a service, sometimes it's necessary to set assign one or more variables at the point of running a command, such as a Rake task. This can be done using `env` e.g.

```
govuk-docker run content-publisher-lite env MY_VAR=my_val bundle exec rake my_task
```

## Licence

[MIT License](LICENCE)
