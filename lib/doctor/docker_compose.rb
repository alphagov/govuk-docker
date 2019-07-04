module Doctor
  class DockerCompose
    def initialize
      @message = []
    end

    def call
      install_state?

      message.join
    end

  private

    attr_reader :message

    DOCKER_COMPOSE_INSTALLED = "✅ Docker Compose is installed".freeze
    INSTALL_DOCKER_COMPOSE = <<~HEREDOC.freeze
      ❌ Docker Compose not found.
      You should install docker by grabbing the latest image from https://docs.docker.com/docker-for-mac/release-notes/.
      For manual installation, visit https://docs.docker.com/compose/install/
    HEREDOC

    def install_state?
      message << if docker_installed?
                   DOCKER_COMPOSE_INSTALLED
                 else
                   INSTALL_DOCKER_COMPOSE
                 end
    end

    def docker_installed?
      system "which docker-compose 1>/dev/null"
    end
  end
end
