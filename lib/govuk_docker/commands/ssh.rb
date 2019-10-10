require_relative "./base"
require_relative "./run"

class GovukDocker::Commands::Ssh < GovukDocker::Commands::Base
  def call(variation = nil)
    stack = variation || "app"
    container_name = "#{service}-#{stack}"

    GovukDocker::Commands::Compose
      .new(config_directory: config_directory, service: service, stack: stack, verbose: verbose)
      .call(["exec", container_name, "/bin/bash"])
  end
end
