require "thor"

require_relative "./commands/build"
require_relative "./commands/compose"
require_relative "./commands/prune"
require_relative "./commands/run"
require_relative "./doctor/dnsmasq"
require_relative "./doctor/docker"

class GovukDockerCLI < Thor
  # https://github.com/ddollar/foreman/blob/83fd5eeb8c4b522cb84d8e74031080143ea6353b/lib/foreman/cli.rb#L29-L35
  class << self
    # Hackery. Take the run method away from Thor so that we can redefine it.
    def is_thor_reserved_word?(word, type)
      return false if word == "run"

      super
    end
  end

  package_name "govuk-docker"

  desc "build", "Build the service in the current directory"
  def build
    Commands::Build.new.call
  end

  desc "compose ARGS", "Run `docker-compose` with ARGS"
  long_desc <<-LONGDESC
    List all stacks across all apps:

    > govuk-docker compose ps --services

    Stop all containers

    > govuk-docker compose stop
  LONGDESC
  def compose(*args)
    Commands::Compose.new.call(*args)
  end

  desc "doctor", "Various tests to help diagnose issues when running govuk-docker"
  def doctor
    puts "Checking dnsmasq"
    puts Doctor::Dnsmasq.new.call
    puts "\r\nChecking docker"
    puts Doctor::Docker.new.call
  end

  desc "prune", "Remove all docker containers, volumes and images"
  def prune
    Commands::Prune.new.call
  end

  desc "run [ARGS]", "Run the service in the current directory with the specified stack (for example `govuk-docker run --stack app`)"
  option :stack, default: "lite"
  def run(*args)
    Commands::Run.new(options[:stack], args).call
  end

  desc "startup [VARIATION]", "Run the service in the current directory with the `app` stack. Variations can be provided, for example `live` or `draft`."
  def startup(variation = nil)
    stack = variation ? "app-#{variation}" : "app"
    Commands::Run.new(stack, []).call
  end
end
