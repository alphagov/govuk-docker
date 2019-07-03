require_relative './base'
require_relative './compose'

class Commands::Build < Commands::Base
  def call
    check_service_exists
    system.call("make", "-f", "#{config_directory}/Makefile", service)
    Commands::Compose.new.call("stop")
    Commands::Prune.new.call
  end
end
