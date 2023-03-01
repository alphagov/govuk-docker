# 2. Docker images for Ruby Applications

Date: 2020-11-17

## Context

In order to run GOV.UK applications in a Docker environment we need
[Docker images][]. GOV.UK had previously created Docker images for various
applications to enable the [publishing-e2e-tests][] suite, which runs a
containerised version of the GOV.UK publishing stack. These images were
defined with a Dockerfile in the root of a project's repository
([example][example-dockerfile]) and, as they are the only Dockerfile for a
project, were essentially the defacto Docker images for GOV.UK applications.

Attempting to reuse these images in the GOV.UK Docker development environment
revealed a number of problems:

1. Any time a Ruby project's Gem dependencies changed the image would need to
   be rebuilt which [required re-installing][gem-install] every single gem,
   which could be a slow process.
2. As Gem dependencies were stored within a project's image no Gems could be
   shared across applications - this meant that the initialisation process
   for multiple GOV.UK apps could be frustratingly slow with the same Gems
   installed in each different image, it also resulted in high disk usage.
3. The images were only exercised in publishing-e2e-tests which ran them
   [in production mode][production], this meant they didn't necessarily have
   sufficient dependencies for development usage  (e.g. Google Chrome for UI
   testing).
4. The images [embedded the application's files][embed-files] - this meant
   that by default any edits to files would require the image to be rebuilt.

Thus we considered whether it would be appropriate to modify these images to
solve the problems or to create different images for GOV.UK Docker.

[Docker images]: https://docs.docker.com/get-started/overview/#images
[publishing-e2e-tests]: https://github.com/alphagov/publishing-e2e-tests
[example-dockerfile]: https://github.com/alphagov/publishing-api/blob/8b6bc39a3f6b73c2c3e73def6a1c2a6e7687d789/Dockerfile
[embed-files]: https://github.com/alphagov/specialist-publisher/blob/33a6f3a5d7c8b5ea79d0cd5a8232ed40391db1ef/Dockerfile#L26
[gem-install]: https://github.com/alphagov/government-frontend/blob/51d86566de33c122aea20f30bcc0fd0d36572752/Dockerfile#L16
[production]: https://github.com/alphagov/publishing-e2e-tests/blob/3c0e50f66c2c61a7bb98eb07cacd4fcf6233fb51/docker-compose.yml#L14

## Decision

We decided that we should not reuse the existing images and that we would
resolve the problems with a different image approach for GOV.UK Docker. While
some of the problems could be resolved we reasoned that the existing images
represent [standard industry practice][docker-rails] for web application images
and that this practice was optimised for running a production instance of an
application. We felt that the needs of production and development were
sufficiently distinct that it would be simpler to have separate images than try
to consolidate.

We instead [created a Dockerfile][base-dockerfile] that is stored in
GOV.UK Docker and this is used by the majority of GOV.UK Docker Ruby projects.
This base Dockerfile contains a collection of common dependencies used by a
significant number of projects. Projects that have additional dependencies
have their [own Dockerfiles][whitehall-dockerfile]. This allowed us to ensure
that projects had their necessary development dependencies.

We resolved the problems for Gem installations with a [shared Docker
mount][home-volume]. Using this allowed the installation, and thus updating,
of Ruby versions and Gems to be done [outside a Docker build
process][ruby-install], meaning these tasks can be achieved without rebuilding
the image. This shared mount is used across projects and allows Ruby and Gem
dependencies to be reused.

We resolved the problem of embedded files with a [mount for the ~/govuk
directory][govuk-mount]. This mount allows containers to access application
code and for this code to be modified without requiring an image rebuild. Using
this broad directory allows projects to access other projects when necessary
which assists working with [local versions of Gems][local-gems].

[docker-rails]: https://docs.docker.com/compose/rails/
[base-dockerfile]: https://github.com/alphagov/govuk-docker/blob/b2fb90dd62a7579976cc3adaa9c783cd92cbd7e7/Dockerfile.govuk-base
[whitehall-dockerfile]: https://github.com/alphagov/govuk-docker/blob/b2fb90dd62a7579976cc3adaa9c783cd92cbd7e7/projects/whitehall/Dockerfile
[home-volume]: https://github.com/alphagov/govuk-docker/blob/b2fb90dd62a7579976cc3adaa9c783cd92cbd7e7/docker-compose.yml#L4
[ruby-install]: https://github.com/alphagov/govuk-docker/blob/b2fb90dd62a7579976cc3adaa9c783cd92cbd7e7/Makefile#L27-L31
[govuk-mount]: https://github.com/alphagov/govuk-docker/blob/b2fb90dd62a7579976cc3adaa9c783cd92cbd7e7/projects/publishing-api/docker-compose.yml#L11
[local-gems]: https://bundler.io/man/gemfile.5.html#PATH

## Status

Accepted

## Consequences

With most GOV.UK Docker projects lacking an individual Dockerfile there is
substantially less Docker configuration to manage and there is a reduced risk
of inconsistencies. This also reduces the difficulty in adding new projects to
GOV.UK Docker.

The containers in GOV.UK Docker lack the property of being a [unit of software
that packages up all code and dependencies][docker-container] which may be
surprising. However, it is unclear that container principles can be easily
applied to Ruby-on-Rails development environments without the problems we
experienced.

By storing the Dockerfile in GOV.UK Docker there is only a very weak coupling
between the minimal set of system packages installed on the image, and those
used by the application. This will mean that changes to system packages need
coordinating in both the application repository and GOV.UK Docker. This is
however a rare occurrence, due to the minimal number of system packages in
the Dockerfile used by GOV.UK Docker.

GOV.UK will have multiple Dockerfiles for the same application raising a risk
of confusion for developers. While [there remains][remove-e2e] a Dockerfile in
the root of repositories developers may expect that this is somewhat related
to the GOV.UK Docker project.

[docker-container]: https://www.docker.com/resources/what-container
[remove-e2e]: https://github.com/alphagov/govuk-rfcs/blob/master/rfc-128-continuous-deployment.md#delete-publishing-e2e-tests
