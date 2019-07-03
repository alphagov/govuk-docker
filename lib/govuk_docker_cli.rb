require "thor"

require_relative "./commands/build_this"
require_relative "./commands/compose"
require_relative "./commands/prune"
require_relative "./commands/run_this"

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

  desc "prune", "Remove all docker containers, volumes and images"
  def prune
    Commands::Prune.new.call
  end

  desc "run-this STACK [ARGS]", "Run the service in the current directory with the specified stack (for example `govuk-docker run-this backend`)"
  def run_this(stack, *args)
    Commands::RunThis.new(stack, args).call
  end
end
