require_relative "./base"
require_relative "../doctor/checkup"

class GovukDocker::Setup::Docker < GovukDocker::Setup::Base
  def call
    return unless check_continue

    install_docker
    install_docker_compose
    puts "✅ Docker and Docker-compose installation and configuration complete!"
  end

private

  def check_continue
    puts "This will install Docker and Docker-compose via Brew."
    shell.yes?("Are you sure you want to continue?")
  end

  def install_docker
    return if GovukDocker::Doctor::Checkup.new(
      service_name: "docker",
      checkups: %i(installed),
      messages: {}
    ).installed?

    puts "⏳ Installing Docker"
    system("brew cask install docker")
  end

  def install_docker_compose
    return if GovukDocker::Doctor::Checkup.new(
      service_name: "docker-compose",
      checkups: %i(installed),
      messages: {}
    ).installed?

    puts "⏳ Installing Docker-compose"
    system("brew install docker-compose")
  end
end
