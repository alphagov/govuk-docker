module Commands
  class Base
    def initialize(service = nil, config_directory = nil, system = nil)
      @config_directory = config_directory || default_config_directory
      @service = service || default_service
      @system = system || default_system
    end

  private

    attr_reader :config_directory, :service

    def check_service_exists
      raise "Unknown service #{service}." unless service_exists?
    end

    def service_exists?
      search_string = "services/#{service}/docker-compose.yml"
      docker_compose_paths.any? { |path| path.include?(search_string) }
    end

    def docker_compose_paths
      base_path = File.join(config_directory, "docker-compose.yml")
      services_path = File.join(config_directory, "services", "*", "docker-compose.yml")
      [base_path] + Dir.glob(services_path)
    end

    def default_config_directory
      File.join(__dir__, "..", "..")
    end

    def default_service
      ENV.fetch("GOVUK_DOCKER_SERVICE", File.basename(Dir.pwd))
    end

    def default_system
      Kernel.method(:system)
    end
  end
end
