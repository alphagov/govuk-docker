require_relative './base'
require_relative './run'

class Commands::Startup < Commands::Base
  def call(variation = nil)
    stack = variation ? "app-#{variation}" : "app"

    Commands::Run
      .new(config_directory: config_directory, service: service, stack: stack, verbose: verbose)
      .call
  end
end
