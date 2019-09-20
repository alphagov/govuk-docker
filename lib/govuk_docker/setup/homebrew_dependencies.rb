require_relative "./base"
require_relative "../doctor/checkup"

class GovukDocker::Setup::HomebrewDependencies < GovukDocker::Setup::Base
  def call
    puts "Installing dependencies via Homebrew..."
    system("brew bundle --file=#{GovukDocker::Paths.govuk_docker_dir}/Brewfile")
  end
end
