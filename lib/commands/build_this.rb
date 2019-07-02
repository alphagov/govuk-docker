require_relative './base'
require_relative './compose'

class Commands::BuildThis < Commands::Base
  def call
    check_service_exists
    Commands::Compose.new.call("build", "#{service}-default")
  end
end
