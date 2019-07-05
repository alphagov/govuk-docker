require_relative "./base"

class Setup::Docker < Setup::Base
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
    puts "⏳ Installing Docker"
    system("brew cask install docker")
  end

  def install_docker_compose
    puts "⏳ Installing Docker-compose"
    system("brew install docker-compose")
  end
end
