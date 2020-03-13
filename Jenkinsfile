#!/usr/bin/env groovy

library("govuk")

node {
  govuk.buildProject(
    skipDeployToIntegration: true,
    rubyLintDiff: false,
    overrideTestTask: {
      stage("Run tests") {
        sh "GOVUK_DOCKER_DIR=. make test"
      }
    }
  )
}
