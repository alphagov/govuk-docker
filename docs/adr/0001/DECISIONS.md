# Decisions

**DEPRECATED: much of what follows was written before we adopted a PR/ADR mechanism for making changes in this repo. Decisions may have changed since they were written here, so what follows should only be used to provide historical context.**

This is a record of decisions in the design of govuk-docker, to support the various needs people have when developing in the GOV.UK ecosystem. Each decision has a reference anchor so it can be linked from its associated need(s).

## Make

### make-clone

Cloning or pulling all of the active GOV.UK repos is a time-consuming activity.

   1. Find the repo on Github
   2. Copy the clone URL
   3. Run `git clone <url>` in the appropriate directory
   4. Repeat for the next repo

For a new developer on GOV.UK, it's also unclear which repos are active or relevant, so for both these reasons, **govuk-docker has scripts to automate the clone/pull process, in the form of `make clone` and `make pull` tasks**.

Manually listing each repo to clone would introduce a maintenance overhead for the script, so with reference to [make-files](#make-files) and [docker-compose](#docker-compose), **govuk-docker groups config files for a service in directories named after their repos**.

### make-files

The commands to setup each service are often specific to the service - even running `bundle` is not uniform across GOV.UK. Having the tasks for each service in a single Makefile would make it difficult to navigate, and difficult to understand the hierarchy of the tasks; trying to combine all the commands into a smaller number of tasks would make it difficult to run them for a specific service. In order to make the task hierarchy of the Makefile clear, avoid a long single Makefile, and support multiple service-specific tasks, **govuk-docker has a Makefile for each service**.

### make-idempotent

If a make task fails, it should be possible to run it again. There are lots of reasons why this could happen, from transient network issues, to making a mistake when developing this repo!

If a make task succeeds, it should be possible to run it again if the environment has changed. For example, with reference to [make-clone](#make-clone), this could be to clone a bunch of new repos.

In order to support failure and changes in environment, **govuk-docker make tasks are all idempotent, which means they can be run any number of times if this is necessary for them to succeed**.

### make-setup

Running all of the individual make tasks is a time-consuming activity.

   1. `make clone`
   2. `make build`
   3. `make -f asset-manager/Makefile`
   4. ...
   5. `make clean`

For a new developer on GOV.UK, it's also unclear which tasks should be run, so for both these reasons, **govuk-docker combines all service-specific tasks into `make setup`, and all top-level tasks into the default `make` task**.

## Docker

### docker-stacks

Most service commands fall into one of two groups:

   - `rake`, `rspec`, `bundle`, etc.
   - `rails s`, `./router`, `sidekiq`, etc.

The first set of commands are related to building and testing a service; then require only minimal dependencies and have many variants. In order to support these commands, **govuk-docker defines a `lite` stack for each service, with minimal dependencies and with specific support for testing** e.g.

```
services:
  my_service-lite:
    environment:
      TEST_DATABASE_URL: ...
      ...
    depends_on:
      - postgres
```

Commands like `rails s` are related to running an app; they may require other apps to be running, but have a fixed form. Sometimes an app can be run in several different configurations e.g. with a worker to run async jobs; or with different environment variables, to make it a 'draft' instance, for example. In order to support these configurations, **govuk-docker defines a variety of app-specific stacks for services that run as apps** e.g.

```
services:
  my_service-app:
    depends_on:
      - postgres
      - another_service-app
      ...
    command: rails s ...

  my_service-app-draft:
    environment:
      PLEK_HOSTNAME_PREFIX: "draft-"
    depends_on:
      - postgres
      - another_service-app-draft
      ...
    command: rails s ...
```

### docker-compose

The config to run each service with docker-compose is specific to the service. Even with some refactoring, the config for each service is still many lines long. Defining multiple stacks for each service compounds the problem.

```
my_service-my_stack:
  image: ...
  build: ...
  volumes: ...
  environment: ...
  command: ...
  privileged: ...
  working_dir: ...
  ports: ...
  depends_on: ...
```

Having all the services defined in a single file would make it difficult to navigate. In order to avoid a long single docker-compose.yml file, **govuk-docker has a docker-compose.yml file for each service**.

### docker-aliases

While the config to run each service with docker-compose is service-specific, there are common elements between each stack. In order to reduce this duplication, **govuk-docker uses x-my_service sections to define the common elements** and relies on YAML aliases to embed the common elements in each stack.

```
x-my_service: &my_service
  image: ...
  build: ...
  ...

services:
  my_service-lite:
    <<: *my_service
    volumes: ...
```

Some duplication also occurs between specific stacks e.g. a 'draft' stack is often an extension of the 'live' one. In order to reduce this duplication, **govuk-docker uses YAML aliases when one service clearly inherits from another**.

### docker-dockerfiles

Running a service command makes use of an image for a particular service/stack pair. It's normal to use a Dockerfile to define how the image is built, and many GOV.UK services contain such a file in their repos. However, there are certain aspects of these files that are not optimised for development:

   - They [hard-code the RAILS_ENV](https://github.com/alphagov/publishing-api/blob/master/Dockerfile#L11), which is unsuitable for testing
   - They [copy the service files into the image](https://github.com/alphagov/publishing-api/blob/master/Dockerfile#L21), which makes them difficult to change
   - They [pre-install volatile dependencies](https://github.com/alphagov/publishing-api/blob/master/Dockerfile#L20), which takes a long time (each time)
   - They [install unnecessary packages](https://github.com/alphagov/publishing-api/blob/master/Dockerfile#L3) in the context of govuk-docker
   - They [set environment variables and a command](https://github.com/alphagov/publishing-api/blob/master/Dockerfile#L13) that are stack-dependent
   - They run service commands as the root user, which breaks headless Chrome

Although many services have similar Dockerfiles, in order to optimise the service images for development and maintain flexibility, **govuk-docker uses its own Dockerfile to build the image for each service**.

### docker-lockfiles

The most appropriate Docker base image for each service is usally related to the associated language e.g. the [ruby](https://hub.docker.com/_/ruby/) base images. From this base image, we then need to install system packages, which change infrequently and can be individually cached as part of the image build process. We then need to install language-specific packages, which change more often (e.g. [dependabot](https://dependabot.com/)) and are harder to cache as they are specified in a versioned lockfile, such as `Gemfile.lock`.

When a lockfile is used as part of the image build process, any change to the lockfile means all of the specified packages need to be reinstalled, since the layer previously cached with the old version of lockfile is no longer valid - the installation of all of the packages makes up one single, volatile layer of the image. In order to avoid long and voluminous image (re)builds, **govuk-docker does not build images to include packages specified using a versioned lockfile**.

### docker-bundle

When developing a Ruby/Rails app natively, it is common to run `bundle` to install/update Ruby packages. With [cli-aliases](#cli-aliases), the equivalent with the govuk-docker CLI would be `gdrd bundle`. However, because of the ephemeral nature of containers, the installed packages would be lost as soon as the command finishes. In order to persist and share packages installed with bundler, **govuk-docker mounts a single, shared `bundle` volume for each Ruby service**.

**This decision also applies to 'go' packages and to the home directory of the 'build' user**, the latter serving as the default user for most of the govuk-docker images and is where some packages are installed e.g. chromedriver.

### docker-mount1

When developing a Ruby/Rails app natively, it is common to make changes to the running code and for these to be immediately visible, without having to run additional commands. In order to support making live changes, **govuk-docker mounts the service directory to `/govuk/my_service`** and does not require service files to be present in the image.

Since the govuk-docker directory is separate from each service directory, in order to mount the service directory it must be possible to locate it using a relative path. In order to mount service directories consistently for each service, **govuk-docker assumes all service directories are located in the same directory as itself**.

### docker-context

When building a docker image for a service, it is common to use the service directory as the build context, and to `COPY` or `ADD` the necessary files into the image. This can often increase the build time when the service directory contains large, unnecessary files, such as logs and tempfiles. Although docker [supports excluding files from the context](https://docs.docker.com/engine/reference/builder/#dockerignore-file), this would involve adding a `.dockerignore` file to each service. [docker-mount1](#docker-mount1) removes the need to copy files in the first place, so in order to minimise the image build time, **govuk-docker uses itself as the build context for all images**.

### docker-mount2

When developing a change across multiple services, it is sometimes necessary to access the files in other service directories. An example of this is developing a local change to a gem, such as [govuk_publishing_components](https://github.com/alphagov/govuk_publishing_components). When running service commands using docker/compose, the service does not have access to any files on the host unless they are mounted. In order to support access to files across different services, and using [docker-7](#docker-7), **govuk-docker mounts all service directories to `/govuk` in the container**.

### docker-bindmount

Docker volumes are separate from 'bind-mounts', which mount part of the host file system in a running container. Bind mounts have [known performance issues on Macs](https://docs.docker.com/docker-for-mac/osxfs-caching/) and even with the latest optimisations, still makes the container impractical. The problem is that read-heavy bind-mounts are not cached between docker commands and [incur system call overheads](https://blog.docker.com/2017/05/user-guided-caching-in-docker-for-mac/#h.mtk84ij3vbkc) that are normally avoided by adding the files to the image as part of the build process.

In order to support [docker-lockfiles](#docker-lockfiles), clarify [docker-bundle](#docker-bundle) and achieve good performance, **govuk-docker only uses docker volumes (and not bind-mounts)** unless there is a specific reason not to. When there is a specific need to use bind-mounts, as in [docker-mount1](#docker-mount1), any writes are often to low-priority log and temporary files, where it's acceptable for the container and the host to diverge if resources are limited. In order to improve write performance, **govuk-docker encourages the use of the [`delegated`](https://docs.docker.com/docker-for-mac/osxfs-caching/#tuning-with-consistent-cached-and-delegated-configurations) flag for all bind-mounts**, which reduces the time for individual write operations.

### docker-imagetag

When a change is made to the Dockerfile for a service, or to the files it reads from, it's necessary to rebuild and tag the associated image. Defining multiple stacks for each service compounds the problem, as this can lead to a each stack having its own image tag, each of which need to be (re)built and (re)tagged separately e.g. using [docker-aliases](#docker-aliases):

```
x-my_service: &my_service
  build: ...

services:
  # image tag is govuk_docker_my_service-my_stack_1
  my_service-my_stack_1:
    <<: *my_service

  # image tag is govuk_docker_my_service-my_stack_2
  my_service-my_stack_2:
    <<: *my_service
```

Although docker will make use of the cached layers for the image to minimise the total build time, having to (remember to) do this for each service/stack pair is inefficient and could lead to subtle bugs, especially when all the images are the same. In order to avoid redundant tags and simplify making changes to the image for a service, **govuk-docker forces the same image tag for all stacks for a service, using the `image` option**, so that all stacks build and run the same image.

### docker-bundleexec

Running commands for a Ruby service is sometimes verbose due to the [`bundle exec`](https://bundler.io/v2.0/man/bundle-exec.1.html) prefix. This prefix is necessary to ensure the command runs in the context of the gems it is 'bundled' with i.e. not the system ones.

Confusingly, it's not always necessary to write this prefix e.g. due to 'helper' scripts [provided by rails](https://github.com/alphagov/content-publisher/tree/master/bin) like `bin/rake`, or [special config](https://github.com/alphagov/content-publisher/blob/master/.rspec) for commands like `rspec`. Both of these examples avoid the need for `bundle exec` by [running the equivalent code in Ruby](https://guides.rubyonrails.org/initialization.html#config-boot-rb). This can also be done by adding `-r bundler/setup` to the `RUBYOPT` environment variable, which will cause `bundler/setup` to be automatically required, but isn't always appropriate e.g. for `bundle install`!

Another approach to solving this problem is to set the [RUBYGEMS_GEMDEPS](https://reinteractive.com/posts/266-no-more-bundle-exec-using-the-new-rubygems_gemdeps-environment-variable) environment variable, which behaves similarly, but (apparently) not identically to `bundle exec` and is [not recommended](https://github.com/bundler/bundler/issues/3656).

Instead of trying to make `bundle exec` implicit in all commands, bundler recommends using [its binstub command](https://bundler.io/man/bundle-binstubs.1.html) to generate wrappers to automate it for particular gems, much like the 'helper' scripts provided by rails. The existing wrappers like `bin/rake` do already many cover common commands in many GOV.UK services. In order to reduce typing, **govuk-docker encourages the addition of bundler binstubs to individual projects as the developers think necessary**.

### docker-debugger

Debugging a Ruby service is often done with the aid of a gem like [byebug](https://github.com/deivid-rodriguez/byebug), using `byebug` or `debugger` breakpoints to activate a prompt in the running command. By default, a docker command does not expose an interactive terminal, which would prevent the use of the prompt for debugger, since it could not receive any input. **Using [docker-compose](https://docs.docker.com/compose/reference/run/) automatically allocates an interactive terminal, so the prompt can be used**.

### docker-binding

Developing a webapp often involves making requests e.g. in the browser, or using CLI tools like `curl`. This can break if the app is running inside a Docker container, since commands like `rails server` and `middleman server` only listen to requests on the local machine (the container) by default. Commands like `rails server` support a `binding` option to change this behaviour e.g. `rails server -b 0.0.0.0` starts a webserver that listens on all interfaces.

Using [docker-stacks](#docker-stacks), the command to start a webserver is specified automatically e.g. `govuk-docker run-this backend` is the same as `govuk-docker run-this backend rails s` but with the additional flag `-b 0.0.0.0`. This may cause confusion if a developer wishes to write a custom command, since the binding flag is docker-specific. In order to avoid confusion and reduce typing, **govuk-docker encourages the use of environment variables to set binding options**.

Currently only [rails](https://github.com/rails/rails/issues/25677) supports this behaviour.

## CLI

### cli-exists

Running a docker-compose command requires the presence of a docker-compose.yml file, which can be [located in the directory tree or specified in the environment](https://docs.docker.com/compose/reference/envvars/#compose_file). Having a docker-compose.yml file in the `govuk` directory tree would make version control difficult, while specifying an environment variable would make it harder to use docker-compose in another context, such as with the [publishing-e2e-tests](https://github.com/alphagov/publishing-e2e-tests), or non-GOV.UK projects.

If we cannot use the config auto-detection feature of docker-compose, then we are left with a few options: (1) specify the file(s) manually or through a temporary env var; (2) navigate to a directory where the file can be auto-detected; or (3) create an abstraction layer for docker-compose. In order to reduce typing, **govuk-docker has a govuk-docker CLI script that runs docker-compose with all the necessary config files**.

### cli-runthis

Outside of the GOV.UK ecosystem, it's normal to run a service command by first `cd`ing to the directory for the service and then typing the command e.g. `whitehall$ rake`. Running a service command with docker-compose looks like this (ignoring config files): `docker-compose run my_service-my_stack command`. If the service is a webapp, then the `--service-ports` flag is also necessary to access the site from a browser on the host machine.

In order to reduce typing, **govuk-docker CLI extends docker-compose with a `run-this` command that automatically infers the `my_service` from the working directory** e.g. `govuk-docker run-this default rake`. The name `run-this` was chosen to be distinct from the existing docker-compose `run` command, to avoid confusion between the two and allow for both commands to be used via the govuk-docker CLI wrapper.

### cli-aliases

Most service commands fall into one of two groups:

   - `govuk-docker run my_service-lite [rake, rspec, bundle, etc.]`
   - `govuk-docker run my_service-web_stack`

In order to reduce typing, **the govuk-docker README recommends the use of aliases for these types of command**. For example, the first can be shortened to `alias gdrd=govuk-docker run-this default` by making use of [cli-exists](#cli-exists). And in order to promote interoperability between govuk-docker commands and native commands, **govuk-docker does not recommend any aliases that override existing commands e.g. `rake`**.

### cli-echo

Using a CLI wrapper for docker/compose has the potential to introduce confusion, especially for someone not familiar with the underlying technology. It may be unclear which commands are native to docker/compose, and which are provided by the script. In order to reduce confusion and make the govuk-docker CLI as transparent as possible, **govuk-docker CLI prints the full form of the dockerc-compose command it wraps**.

### cli-buildthis

Sometimes it's necessary to (re)build the image for a specific service. This could be due to a new version of the language used by the service, or other iterations of its Dockerfile. Using [cli-exists](#cli-exists), this can be written as `gd build my_service-lite`. Although this is supported by [make-setup](#make-setup), which covers all services, it can also take a long time to run. If the changes were pulled en-masse, it may also be unclear which service images need (re)building, or the developer may simply forget they need to do this, or defer (re)building until the point of use. For these reasons, it may be necessary to (re)build an image at the point of use i.e. when trying to run a service command. In order to support this, and using [docker-stacks](#docker-stacks), **govuk-docker CLI extends docker-compose with a `build` command that automatically infers the service image to (re)build, using the default stack** for the service.

### cli-env

Running a service command may require certain environment variables to be set temporarily e.g. in order to pass options to a `rake` task. Natively this would be written `VAR1=val1 VAR2=val2 ... CMD`. This approach isn't compatible with the docker/compose CLI and normally it would be necessary to use the [-e option](https://docs.docker.com/compose/reference/run/) instead. In order to retain the native approach for environment variables, when using [cli-runthis](#cli-runthis) **govuk-docker CLI executes the specified command via the `env` command, which will read any temporary environment variables**. Using [cli-aliases](#cli-aliases), a command that requires temporary environment variables can now be written `gdrd VAR1=val1 VAR2=val2 ... CMD`.

## Web Requests

### web-nginx

Running a web app natively makes it available on a specific port; for rails apps, it's common to manually navigate to `http://localhost:3000` in order to test the app. This approach doesn't scale for multiple apps: it's unclear which app is on each port, and hard to avoid clashes. When the apps are inter-dependent and running inside containers, each with their own virtual network address, it fails completely. Both problems suggest the use of DNS e.g.

```
# /etc/hosts on the host
127.0.0.1 publishing-api.dev.gov.uk

# docker-compose.yml
services:
  publishing-api-app:
    ...
    ports:
      - "80:80"
    networks:
      default:
        aliases:
          - publishing-api.dev.gov.uk
```

The approach for the host machine does not scale beyond a single container, unless that container acts as a proxy to all the others. In order to simplify web requests to each app, **govuk-docker uses the [nginx-proxy](https://github.com/jwilder/nginx-proxy) image to automatically proxy web requests from other service containers and from the host machine**. When the app has multiple stacks that run concurrently, such as a 'draft' stack and a 'live' stack, then it's essential to use multiple DNS names or 'virtual hosts' in order to distinguish them; otherwise, **govuk-docker uses the same virtual host for each stack for an app**.

### web-dnsmasq

In order to minimise the manual setup required on the host machine, **govuk-docker uses dnsmasq to automatically map `*.dev.gov.uk` to the localhost**.
