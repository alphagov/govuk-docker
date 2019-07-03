require 'yaml'
require_relative '../errors/unknown_service'
require_relative '../errors/unknown_stack'

module Commands
  class Base
    def initialize(service = nil, config_directory = nil, system = nil, stack = nil, verbose = false)
      @service = service || default_service
      @config_directory = config_directory || default_config_directory
      @system = system || default_system
      @stack = stack
      @verbose = verbose
    end

  private

    attr_reader :config_directory, :service, :system, :stack, :verbose

    def available_stacks
      service_path = File.join(config_directory, "services/#{service}/docker-compose.yml")
      service_file = YAML.load_file(service_path)
      @available_stacks ||= service_file["services"].map do |service_with_stack|
        service_with_stack.first.delete_prefix(service + '-')
      end
    end

    def check_service_exists
      raise UnknownService.new(service, config_directory) unless service_exists?
    end

    def check_stack_exists
      raise UnknownStack.new(stack, available_stacks) unless stack_exists?
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

    def service_exists?
      search_string = "services/#{service}/docker-compose.yml"
      docker_compose_paths.any? { |path| path.include?(search_string) }
    end

    def stack_exists?
      available_stacks.include?(stack)
    end
  end
end
