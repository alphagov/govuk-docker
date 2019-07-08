require_relative './base'
require_relative './compose'

class GovukDocker::Commands::Build < GovukDocker::Commands::Base
  def call
    check_service_exists
    system_command "make", "-f", "#{config_directory}/Makefile", service
  end
end
