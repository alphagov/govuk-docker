require_relative './base'
require_relative './compose'

class Commands::Run < Commands::Base
  def initialize(args, config_directory = nil, service = nil, stack = nil, verbose = false)
    super(config_directory, service, stack, verbose)
    @args = args
  end

  def call
    check_service_exists
    check_stack_exists
    Commands::Compose.new.call(
      verbose, "run", "--rm", "--service-ports", container_name, *extra_args
    )
  end

private

  attr_reader :args

  def container_name
    "#{service}-#{stack}"
  end

  def extra_args
    return [] if args.empty?
    return args if args.first == "env"

    %w[env] + args
  end
end
