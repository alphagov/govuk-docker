# Installation

## Prerequisites

govuk-docker has the following dependencies:

- [brew](https://brew.sh/). (If you don't use a Mac, you'll need to dig into the `govuk-docker setup` command and manually install the things referenced).
- [git](https://git-scm.com)
- Ruby (whatever version is specified in [.ruby-version](https://github.com/alphagov/govuk-docker/blob/master/.ruby-version))
  - Follow these [instructions to update Ruby using brew](#how-to-install-or-update-ruby)
- A directory `~/govuk` in your home directory

All other dependencies will be installed for you automatically.

### Docker settings
Running GOV.UK applications can be resource intensive and will easily exceed the default configuration of Docker for Mac. To change settings open the Docker dropdown via the Docker whale icon in the macOS menu bar, and select the preferences option.

In `Advanced` settings you should update CPU and RAM resources. These should be at least:

* 6 CPUs
* 12 GB RAM

In `Disk` you should ensure there is a high amount of disk space to allow replicating GOV.UK data. 64GB should be sufficient for most usages but you may need > 100GB to clone all GOV.UK integration data.

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

## Environment variables

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

Then install the correct version of Ruby listed in [.ruby-version](https://github.com/alphagov/govuk-docker/blob/master/.ruby-version) - *note* you need to clone this repository (govuk-docker) into `~/govuk` first!

```
cd ~/govuk/govuk-docker
rbenv install
```

Now, when you are in the `~/govuk/govuk-docker` folder, rbenv will automatically switch to the correct version of Ruby - check this by running `ruby -v`.

### How to: install bundler

To install [bundler](https://bundler.io/), first find out the required version (in X.Y.Z format) from [Gemfile.lock](https://github.com/alphagov/govuk-docker/blob/master/Gemfile.lock) - it will be listed as:

```
BUNDLED WITH
    X.Y.Z
```

Install the correct version of bundler; you may have to overwrite existing bundle and bundler executable conflicts.

```
gem install bundler:X.Y.Z
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

### How to: set up Dnsmasq manually

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
