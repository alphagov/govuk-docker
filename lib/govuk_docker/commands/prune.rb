require_relative "./base"

class GovukDocker::Commands::Prune < GovukDocker::Commands::Base
  def call
    puts "DEPRECATED: use 'govuk-docker compose rm -sv' instead"
  end
end
