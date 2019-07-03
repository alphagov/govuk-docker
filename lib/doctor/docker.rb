module Doctor
  class Docker
    def initialize
      @message = []
    end

    def call
      install_state?

      message.join
    end

  private

    attr_reader :message

    DOCKER_INSTALLED = "✅ Docker is installed".freeze
    INSTALL_DOCKER = <<~HEREDOC.freeze
      ❌ Docker not found.
      You should install docker by grabbing the latest image from https://docs.docker.com/docker-for-mac/release-notes/.
      For manual installation, visit https://docs.docker.com/install/.
    HEREDOC

    def install_state?
      message << if docker_installed?
                   DOCKER_INSTALLED
                 else
                   INSTALL_DOCKER
                 end
    end

    def docker_installed?
      system "which docker 1>/dev/null"
    end
  end
end
