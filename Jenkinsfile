#!/usr/bin/env groovy

library("govuk")

node {
  govuk.buildProject(
    skipDeployToIntegration: true,
    overrideTestTask: {
      stage("Run tests") {
        govuk.withStatsdTiming("test_task") {
          sh "make test"
        }
      }
    }
  )
}
