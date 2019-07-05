require 'yaml'
require_relative '../paths'
require_relative '../errors/unknown_service'
require_relative '../errors/unknown_stack'

module Commands
  class Base
    def initialize(options = {})
      @config_directory = options[:config_directory] || default_config_directory
      @service = options[:service] || default_service
      @stack = options[:stack] || default_stack
      @verbose = options[:verbose] || default_verbose
    end

    def system_command(*args)
      system(*args) || raise("Non-zero exit code")
    end

    def service_exists?
      search_string = "services/#{service}/docker-compose.yml"
      docker_compose_paths.any? { |path| path.include?(search_string) }
    end

    def stack_exists?
      available_stacks.include?(stack)
    end

    def check_service_exists
      raise UnknownService.new(service, config_directory) unless service_exists?
    end

    def check_stack_exists
      raise UnknownStack.new(stack, available_stacks) unless stack_exists?
    end

  private

    attr_reader :config_directory, :service, :stack, :verbose

    def available_stacks
      service_path = File.join(config_directory, "services/#{service}/docker-compose.yml")
      service_file = YAML.load_file(service_path)
      @available_stacks ||= service_file["services"].map do |service_with_stack|
        service_with_stack.first.delete_prefix(service + '-')
      end
    end

    def docker_compose_paths
      base_path = File.join(config_directory, "docker-compose.yml")
      services_path = File.join(config_directory, "services", "*", "docker-compose.yml")
      [base_path] + Dir.glob(services_path)
    end

    def default_config_directory
      GovukDocker::Paths.govuk_docker_dir
    end

    def default_service
      ENV.fetch("GOVUK_DOCKER_SERVICE", File.basename(Dir.pwd))
    end

    def default_stack
      "lite"
    end

    def default_verbose
      false
    end
  end
end
