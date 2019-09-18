require_relative "./base"
require_relative "../doctor/checkup"

class GovukDocker::Setup::HomebrewDependencies < GovukDocker::Setup::Base
  def call
    return unless check_continue

    system("brew bundle --file=#{GovukDocker::Paths.govuk_docker_dir}/Brewfile")
  end

private

  def check_continue
    puts "This will install all the dependencies via Homebrew."
    shell.yes?("Are you sure you want to continue?")
  end
end
