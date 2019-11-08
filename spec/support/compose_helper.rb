module ComposeHelper
  def compose_app_services
    compose_files = Dir.glob("services/**/docker-compose.yml")

    @compose_app_services ||= compose_files.flat_map do |filename|
      YAML.load_file(filename)["services"].to_a.select do |service_name, _service|
        service_name =~ /app(-\w+)?$/
      end
    end
  end

  def compose_services(name)
    filename = File.join("services", name, "docker-compose.yml")
    YAML.load_file(filename)["services"]
  end
end
