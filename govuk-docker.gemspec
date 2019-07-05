# -*- encoding: utf-8 -*-

lib = File.expand_path("lib", __dir__)
$:.unshift lib unless $:.include?(lib)

require "govuk_docker/version"

Gem::Specification.new do |s|
  s.name         = "govuk-docker"
  s.version      = GovukDocker::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["GOV.UK Dev"]
  s.email        = ["govuk-dev@digital.cabinet-office.gov.uk"]
  s.summary      = "Docker-based GOV.UK environment"
  s.homepage     = "http://github.com/alphagov/govuk-docker"
  s.description  = "A local environment for GOV.UK powered by Docker"

  s.required_ruby_version = ">= 2.6.0"
  s.files        = Dir.glob("lib/**/*") + %w(README.md)
  s.require_path = "lib"
  s.add_dependency "colorize"
  s.add_dependency "thor"

  s.add_development_dependency "climate_control"
  s.add_development_dependency "govuk-lint"
  s.add_development_dependency "pry"
  s.add_development_dependency "rspec"
end
