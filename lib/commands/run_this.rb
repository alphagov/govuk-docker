require_relative './base'
require_relative './compose'

class Commands::RunThis < Commands::Base
  def initialize(stack, args, service = nil, config_directory = nil)
    super(service, config_directory)
    @stack = stack
    @args = args
  end

  def call
    check_service_exists
    Commands::Compose.new.call(
      "run", "--rm", "--service-ports", container_name, *extra_args
    )
  end

private

  attr_reader :stack, :args

  def container_name
    "#{service}-#{stack}"
  end

  def extra_args
    return [] if args.empty?
    return args if args.first == "env"
    ["env"] + args
  end
end
