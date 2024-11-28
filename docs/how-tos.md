# How Tos

👉 [Check the troubleshooting guide if you have a problem.](troubleshooting.md#installation)

## How to: get back to a clean slate

If you encounter an issue with your Docker setup and you've already exhausted all other ideas, here's a quick one-liner that stops and removes absolutely everything. You can then follow the govuk-docker README instructions for `make`-ing your app again.

```
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q) && docker rmi $(docker images -q) -f && docker volume prune && docker container prune && docker image prune && docker network prune && docker system prune --all --volumes
```

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
gds aws govuk-integration-poweruser --assume-role-ttl 3h ./bin/replicate-postgresql.sh content-publisher

# as an AWS User...
gds aws govuk-integration-readonly --assume-role-ttl 3h ./bin/replicate-postgresql.sh content-publisher
```

All the scripts, other than `replicate-elasticsearch.sh`, take the name of the app to replicate data for.

Draft data can be replicated with `replicate-postgresql.sh draft-content-store` and `replicate-mongodb.sh draft-router`.

If you want to download data without importing it, set the `SKIP_IMPORT` environment variable (to anything).

### Troubleshooting

The replication scripts might fail for the following reasons:

- `pv` not being installed. This is used to display a progress bar. On macOS, you can [install pv using Homebrew](https://formulae.brew.sh/formula/pv).
- Running out of space in Docker. This might result in an error like `ERROR 1114 (HY000) at line 11768: The table 'govspeak_contents' is full`. If you see this, you could do either or both of the following:
  - If you're okay with removing some or all of your Docker containers, images, and possibly volumes and other data, run [docker system prune](https://docs.docker.com/reference/cli/docker/system/prune).
  - If you have enough spare space on your local machine, allocate more space to Docker. Using Docker Desktop, this setting is under Settings > Resources > Advanced > Resource Allocation > Virtual disk limit.

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

## How to: publish a finder and specialist documents to test finders end-to-end locally

See [How to Publish Content to a Finder in GOV.UK Docker](./how-tos/finder-setup.md)

## How to: Re-run `make` without branch checks

If you have already run `make` for a project recently, and just want to re-run it without it
checking for updates to all dependent repositories (for example if you do not have a stable internet
connection), you can set the `SKIP_BRANCH_CHECKS` environment variable:
```bash
SKIP_BRANCH_CHECKS=1 make my-app
```
