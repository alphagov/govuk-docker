require_relative "./base"
require_relative "./compose"

class GovukDocker::Commands::Run < GovukDocker::Commands::Base
  def call(args = [])
    check_service_exists
    check_stack_exists

    GovukDocker::Commands::Compose
      .new(config_directory: config_directory, service: service, stack: stack, verbose: verbose)
      .call(
        ["run", "--rm", container_name] + args,
      )
  end

private

  attr_reader :args

  def container_name
    "#{service}-#{stack}"
  end
end
