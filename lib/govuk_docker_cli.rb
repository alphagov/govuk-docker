require "thor"

require_relative "./commands/build_this"
require_relative "./commands/compose"
require_relative "./commands/prune"
require_relative "./commands/run_this"

class GovukDockerCLI < Thor
  desc "build-this", "build the current service"
  def build_this
    Commands::BuildThis.new.call
  end

  desc "compose ARGS", "passes ARGS to docker-compose"
  def compose(*args)
    Commands::Compose.new.call(*args)
  end

  desc "prune", "remove all docker containers, volumes and images"
  def prune
    Commands::Prune.new.call
  end

  desc "run-this STACK [ARGS]", "run the current service in the stack with optional args"
  def run_this(stack, *args)
    Commands::RunThis.new(stack, args).call
  end
end
