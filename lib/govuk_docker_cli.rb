require "thor"

require_relative "./commands/build"
require_relative "./commands/compose"
require_relative "./commands/prune"
require_relative "./commands/run"
require_relative "./doctor/dnsmasq"
require_relative "./doctor/docker"
require_relative "./doctor/docker_compose"
require_relative "./install/dnsmasq"

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

  desc "build [ARGS]", "Build a service"
  long_desc <<~LONGDESC
    By default, it builds the service in the current directory.
    It can build a different service if specified (e.g. `govuk-docker build --service static`).
  LONGDESC
  option :service, default: nil
  def build
    Commands::Build.new(nil, options[:service]).call
  end

  desc "compose ARGS", "Run `docker-compose` with ARGS"
  long_desc <<-LONGDESC
    List all stacks across all apps:

    > govuk-docker compose ps --services

    Stop all containers

    > govuk-docker compose stop
  LONGDESC
  option :verbose, type: :boolean, default: false
  def compose(*args)
    Commands::Compose.new.call(options[:verbose], *args)
  end

  desc "doctor", "Various tests to help diagnose issues when running govuk-docker"
  def doctor
    puts "Checking dnsmasq"
    puts Doctor::Dnsmasq.new.call
    puts "\r\nChecking docker"
    puts Doctor::Docker.new.call
    puts "\r\nChecking docker-compose"
    puts Doctor::DockerCompose.new.call
  end

  desc "install", "Configures and installs the various dependencies necessary to run govuk-docker successfully"
  def install
    Install::Dnsmasq.new.call
  end

  desc "prune", "Remove all docker containers, volumes and images"
  def prune
    Commands::Prune.new.call
  end

  desc "run [ARGS]", "Run a service"
  long_desc <<~LONGDESC
    By default, it runs the service in the current directory with the `lite` stack.
    It can run a different service if specified (e.g. `govuk-docker run --service static`).
    It can run with a different stack if specified (e.g. `govuk-docker run --stack app`).
    These two options can be combined (e.g. `govuk-docker run --service static --stack app`).
  LONGDESC
  option :stack, default: "lite"
  option :service, default: nil
  option :verbose, type: :boolean, default: false
  def run(*args)
    Commands::Run.new(nil, options[:service], options[:stack], options[:verbose]).call(args)
  end

  desc "startup [VARIATION]", "Run the service in the current directory with the `app` stack. Variations can be provided, for example `live` or `draft`."
  option :service, default: nil
  option :verbose, type: :boolean, default: false
  def startup(variation = nil)
    stack = variation ? "app-#{variation}" : "app"
    Commands::Run.new(nil, options[:service], stack, options[:verbose]).call
  end
end
