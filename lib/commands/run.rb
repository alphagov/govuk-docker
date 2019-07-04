require_relative './base'
require_relative './compose'

class Commands::Run < Commands::Base
  def call(args = [])
    check_service_exists
    check_stack_exists

    Commands::Compose
      .new(config_directory, service, stack, verbose)
      .call(
        ["run", "--rm", "--service-ports", container_name] + docker_compose_args(args)
      )
  end

private

  attr_reader :args

  def container_name
    "#{service}-#{stack}"
  end

  def docker_compose_args(args)
    return [] if args.empty?
    return args if args.first == "env"

    %w[env] + args
  end
end
