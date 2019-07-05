class UnknownService < Thor::Error
  def initialize(service, config_directory)
    @service = service
    @config_directory = config_directory
    super(message)
  end

  def message
    <<~ERROR_MESSAGE
      Unknown service: #{service}.\n
      Available services:\n
      #{available_services.join("\n")}
    ERROR_MESSAGE
  end

private

  attr_reader :service, :config_directory

  def available_services
    service_folders = File.join(config_directory, "services", '*')
    Dir.glob(service_folders).sort.map do |service|
      File.basename(service)
    end
  end
end
