require "thor"

require_relative "./commands/build_this"
require_relative "./commands/compose"
require_relative "./commands/prune"
require_relative "./commands/run_this"
require_relative "./doctor/dnsmasq"

class GovukDockerCLI < Thor
  package_name "govuk-docker"

  desc "build-this", "Build the service in the current directory"
  def build_this
    Commands::BuildThis.new.call
  end

  desc "compose ARGS", "Run `docker-compose` with ARGS"
  def compose(*args)
    Commands::Compose.new.call(*args)
  end

  desc "doctor", "Various tests to help diagnose issues when running govuk-docker"
  def doctor
    puts "Checking dnsmasq"
    puts Doctor::Dnsmasq.new.call
  end

  desc "prune", "Remove all docker containers, volumes and images"
  def prune
    Commands::Prune.new.call
  end

  desc "run-this [ARGS]", "Run the service in the current directory with the specified stack (for example `govuk-docker run-this --stack backend`)"
  option :stack, default: "default"
  def run_this(*args)
    Commands::RunThis.new(options[:stack], args).call
  end
end
