require_relative "./base"
require_relative "./run"

class GovukDocker::Commands::Startup < GovukDocker::Commands::Base
  def call(variation = nil)
    stack = variation ? "app-#{variation}" : "app"

    GovukDocker::Commands::Run
      .new(config_directory: config_directory, service: service, stack: stack, verbose: verbose)
      .call
  end
end
