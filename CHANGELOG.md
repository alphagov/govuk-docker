# CHANGELOG

## 2.0.0

* BREAKING: Ruby docker containers now run as root
* BREAKING: Renamed database containers and volumes to reflect version numbers
* PhantomJS removed from the stack

All Ruby projects need to be rebuilt and existing database data may be lost.
Information on how to upgrade is available at: https://github.com/alphagov/govuk-docker/pull/394

## 1.0.0

* Signify that GOV.UK Docker is stable and ready for widespread use.

## 0.0.2

* Fix issue with Jasmine tests using PhantomJS (issue with OpenSSL)

You’ll need to run 'govuk-docker build <project>-lite' to apply the fix.

## 0.0.1

* Introduce versioning feature to support people when things change
