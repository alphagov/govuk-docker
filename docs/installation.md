# Installation

## Prerequisites

govuk-docker has the following dependencies:

- [brew](https://brew.sh/)
- [git](https://git-scm.com)
- [Ruby](#how-to-install-or-update-ruby)
- A directory `~/govuk` in your home directory

All other dependencies will be installed for you automatically.

## Setup

Start with the following in your bash config.

```
export PATH=$PATH:~/govuk/govuk-docker/exe
```

Now in the `~/govuk` directory, run the following commands.

```
git clone git@github.com:alphagov/govuk-docker.git
cd govuk-docker
bundle install
bin/setup
```

You can now [clone and setup the apps you need](../README.md#Usage), after which you can do things like run tests and startup the app in your browser. If this doesn't work for whatever reason, follow the [instructions on how to resolve setup issues](#how-tos).

### Docker settings

Running GOV.UK applications can be resource intensive. To give Docker more resources on Mac, click the Docker whale icon in the macOS menu bar, select 'Preferences'. We suggest the following minimum resources:

* 6 CPUs
* 12 GB RAM
* 64GB+ Disk

### Shortcuts

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

### Environment variables

Both govuk-docker and the Makefile respect the following environment variables:

- `$GOVUK_ROOT_DIR` - directory where app repositories live, defaults to `$HOME/govuk`
- `$GOVUK_DOCKER_DIR` - directory where the govuk-docker repository lives, defaults to `$GOVUK_ROOT_DIR/govuk-docker`
- `$GOVUK_DOCKER` - path of the govuk-docker script, defaults to `$GOVUK_DOCKER_DIR/bin/govuk-docker`

## How to's

### How to: troubleshoot your installation

The `doctor` script will attempt to ensure your installation is in a runnable
state and suggest remedial steps if it finds anything wrong

```
bin/doctor
```

This will test whether or not your system meets the following requirements:

* dnsmasq installed and running
* docker installed
* docker-compose installed


### How to: install or update Ruby

Follow the instructions to install [rbenv](https://github.com/rbenv/rbenv#installation) using [brew](https://brew.sh/).

Then install the correct version of Ruby listed in [.ruby-version](https://github.com/alphagov/govuk-docker/blob/master/.ruby-version).

```
cd ~/govuk/govuk-docker
rbenv install
gem install bundler
```

### How to: resolve issues caused by an existing docker install

You may get one of the following errors when running `bin/setup`.

```
Error: The `brew link` step did not complete successfully
The formula built, but is not symlinked into /usr/local
Could not symlink bin/docker-compose
Target /usr/local/bin/docker-compose
...
```

```
Error: It seems there is already an App at '/Applications/Docker.app'.
```

This isn't a problem if you already have Docker/Compose installed, and the setup script will continue to run. If you like, you can remove your existing Docker/Compose and run `bin/setup` again.

### How to: troubleshoot dnsmasq

Sometimes dnsmasq doesn't install correctly. Here are some checks you can do.

* Check if `dev.gov.uk` works end-to-end

```
dig app.dev.gov.uk @127.0.0.1

# output should contain...
# app.dev.gov.uk.		0	IN	A	127.0.0.1
```

* Check your `/etc/resolver` config is working

```
scutil --dns

# output should contain...
# domain   : intro-to-docker.gov.uk
# nameserver[0] : 127.0.0.1
# port     : 53
# flags    : Request A records, Request AAAA records
# reach    : 0x00030002 (Reachable,Local Address,Directly Reachable Address)
```

You can also look at the command in `bin/setup` to see what's changing.
