# How To's

👉 [Check the troubleshooting guide if you have a problem.](troubleshooting.md#installation)

## How to: reduce typing with shortcuts

Typing the [full commands](../README.md#usage) is likely to get tiring. We've added a couple of lightweight helper scripts alongside govuk-docker, which figure out the application you're running based on the name of the current directory.

```
# full commands
govuk-docker run content-publisher-lite bundle exec rake
govuk-docker up content-publisher-app

# shortcuts
# assuming you're in the content-publisher directory
govuk-docker-run bundle exec rake
govuk-docker-up
```

Here are some suggested aliases that make things even shorter.

```
alias gd="govuk-docker"
alias gdr="govuk-docker-run"
alias gdu="govuk-docker-up"
alias gdbe="govuk-docker-run bundle exec"
```

## How to: work with local gems

Provide a local gem path relative to the location of the Gemfile you're editing:

```ruby
gem "govuk_publishing_components", path: "../govuk_publishing_components"
```

## How to: replicate data locally

There may be times when a full database is required locally.  The following scripts in the `bin` directory allow replicating data from integration:

- `replicate-elasticsearch.sh`
- `replicate-mongodb.sh APP-NAME`
- `replicate-mysql.sh APP-NAME`
- `replicate-postgresql.sh APP-NAME`

You will need to assume-role into AWS using the [gds-cli](https://docs.publishing.service.gov.uk/manual/access-aws-console.html) before running the scripts. For example, to replicate data for Content Publisher, run:

```
# as an AWS PowerUser...
gds aws govuk-integration-poweruser --assume-role-ttl 180m ./bin/replicate-postgresql.sh content-publisher

# as an AWS User...
gds aws govuk-integration-readonly --assume-role-ttl 180m ./bin/replicate-postgresql.sh content-publisher
```

All the scripts, other than `replicate-elasticsearch.sh`, take the name of the app to replicate data for.

Draft data can be replicated with `replicate-mongodb.sh draft-content-store` and `replicate-mongodb.sh draft-router`.

If you want to download data without importing it, set the `SKIP_IMPORT` environment variable (to anything).

## How to: set environment variables

While most environment variables should be set in the config for a project, sometimes it's necessary to set assign one or more variables at the point of running a command, such as a Rake task. This can be done using `env` e.g.

```
govuk-docker run content-publisher-lite env MY_VAR=my_val bundle exec rake my_task
```

## How to: debug a running Rails app

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

## How to: use a custom working directory

GOV.UK Docker should respect the following environment variables:

- `$GOVUK_ROOT_DIR` - directory where app repositories live, defaults to `$HOME/govuk`
- `$GOVUK_DOCKER_DIR` - directory where the govuk-docker repository lives, defaults to `$GOVUK_ROOT_DIR/govuk-docker`
- `$GOVUK_DOCKER` - path of the govuk-docker script, defaults to `$GOVUK_DOCKER_DIR/bin/govuk-docker`


## How to: enable production JSON logs in development

- Set `GOVUK_RAILS_JSON_LOGGING` to `"true"` in `docker-compose.yml` for the application you would like to enable the logs' behaviour for.
