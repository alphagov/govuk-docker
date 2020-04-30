# GOV.UK Docker

GOV.UK development environment using Docker.

![diagram](docs/diagram.png)

The GOV.UK website uses a microservice architecture. Developing in this ecosystem is a challenge, due to the range of environments to maintain, both for the app being developed and its dependencies.

The aim of govuk-docker is to make it easy to develop any GOV.UK app. It achieves this by providing a variety of environments or _stacks_ for each app, in which you can run tests, start a debugger, publish a document end-to-end.

[RFC 106: Use Docker for local development](https://github.com/alphagov/govuk-rfcs/blob/master/rfc-106-docker-for-local-development.md) describes the background for choosing Docker. See the [list of projects which work with govuk-docker](docs/compatibility.md).

## Installation

👇👇👇👇👇👇👇👇👇👇👇

[Instructions for how to install and setup govuk-docker are here.](docs/installation.md)

☝️ ☝️ ☝️ ☝️ ☝️ ☝️ ☝️ ☝️ ☝️ ☝️ ☝️

## Usage

Do this to run the tests for a project:

```sh
make collections-publisher

cd ~/govuk/collections-publisher

govuk-docker run collections-publisher-lite bundle exec rake
```

Do this to start a GOV.UK web app:

```sh
make collections-publisher

cd ~/govuk/collections-publisher

# Start collections-publisher including dependencies.
# Visit it at collections-publisher.dev.gov.uk
govuk-docker up collections-publisher-app
```

For a full list of govuk-docker commands, run `govuk-docker help`.

## Stacks

Each project provides a number of 'stacks' for different use cases.
You can see the stacks for a project in its [config file](projects/content-publisher/docker-compose.yml).
To provide consistency we have a convention for these names:

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

### Interoperability of stacks

Even if an e2e stack is started, functionality won't necessarily work as expected "end to end" as govuk-docker doesn't mimick the routing we have on GOV.UK. For example, publishing apps that link to draft-origin.dev.gov.uk frontends will see a server error, as draft-origin isn't a project in govuk-docker.

In these cases, you can swap out the URL for the relevant frontend (such as draft-collections.dev.gov.uk). It's also worth noting that this frontend will need to be started separately, as publishing apps don't define frontend apps in their dependencies; a publishing app doesn't need its corresponding frontend in order to be able to publish.

## How to's

### How to: diagnose and troubleshoot

Sometimes things go wrong or some investigation is needed. As govuk-docker is just a bunch of docker config and a CLI wrapper, it's still possible to use all the standard docker commands to help fix issues and get more info e.g.

```
# make sure govuk-docker is up-to-date
git pull

# make sure the project is built OK
make <project>

# check if any dependencies have exited
docker ps -a

# tail logs for running services/dependencies
govuk-docker logs -f publishing-api-app

# try clearing all containers / volumes
govuk-docker rm -sv
```

### How to: update everything!

Sometimes it's useful to get all changes for all repos e.g. to support finding things with a govuk-wide grep. This can be done by running:

```
make pull
```

### How to: work with local gems

Provide a local gem path relative to the location of the Gemfile you're editing:

```ruby
gem "govuk_publishing_components", path: "../govuk_publishing_components"
```

### How to: replicate data locally

There may be times when a full database is required locally.  The following scripts in the `bin` directory allow replicating data from integration:

- `replicate-elasticsearch.sh`
- `replicate-mongodb.sh APP-NAME`
- `replicate-mysql.sh APP-NAME`
- `replicate-postgresql.sh APP-NAME`

You will need to assume-role into AWS using the [gds-cli](https://docs.publishing.service.gov.uk/manual/access-aws-console.html) before running the scripts. For example, to replicate data for Content Publisher, run:

```
# as an AWS PowerUser...
gds aws govuk-integration-poweruser ./bin/replicate-postgresql.sh content-publisher

# as an AWS User...
gds aws govuk-integration-readonly ./bin/replicate-postgresql.sh content-publisher
```

All the scripts, other than `replicate-elasticsearch.sh`, take the name of the app to replicate data for.

Draft data can be replicated with `replicate-mongodb.sh draft-content-store` and `replicate-mongodb.sh draft-router`.

If you want to download data without importing it, set the `SKIP_IMPORT` environment variable (to anything).

### How to: set environment variables

While most environment variables should be set in the config for a project, sometimes it's necessary to set assign one or more variables at the point of running a command, such as a Rake task. This can be done using `env` e.g.

```
govuk-docker run content-publisher-lite env MY_VAR=my_val bundle exec rake my_task
```

### How to: debug a running Rails app

Normally it's enough to run a Rails app using `govuk-docker up`. To get a `debugger` console for a specific app or one of its dependencies, we need to attach an interactive terminal to the running container.

```
# find the container name
govuk-docker ps

# attach to the container
docker attach govuk-docker_content-publisher-app_1

# awesome debugging stuff
...

# detach from the container
CTRL-P CTRL-Q
```

## Licence

[MIT License](LICENCE)
