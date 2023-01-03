module ComposeHelper
  def self.app_services
    @app_services ||= all_services.select do |service_name, _service|
      service_name =~ /app(-\w+)?$/
    end
  end

  def self.rails_app_services
    app_services.select do |_service_name, service|
      service["command"] =~ /rails/
    end
  end

  def self.lite_services
    @lite_services ||= all_services.select do |service_name, _service|
      service_name =~ /lite$/
    end
  end

  def self.all_services
    @all_services ||= ProjectsHelper.all_projects
                          .map { |project_name| services(project_name) }
                          .reduce({}) { |memo, config| memo.merge(config) }
  end

  def self.services(name)
    filename = File.join("projects", name, "docker-compose.yml")
    YAML.load_file(filename, aliases: true)["services"]
  end
end
