require "spec_helper"

RSpec.describe "Compose service stacks" do
  service_names ||= Dir.glob("*", base: "services")

  service_names.each do |service_name|
    it "configures #{service_name} with a lite or app stack" do
      expect(compose_services(service_name).keys).to include(/lite/)
        .or include(/app(-\w+)?$/)
    end
  end

  compose_files = Dir.glob("services/**/docker-compose.yml")

  compose_app_services = compose_files.flat_map do |filename|
    YAML.load_file(filename)["services"].to_a.select do |service_name, _service|
      service_name =~ /app(-\w+)?$/
    end
  end

  compose_app_services.each do |service_name, service|
    it "configures #{service_name} with a default command" do
      expect(service["command"]).to_not be_nil
    end
  end

  compose_lite_services = compose_files.flat_map do |filename|
    YAML.load_file(filename)["services"].to_a.select do |service_name, _service|
      service_name =~ /lite$/
    end
  end

  compose_lite_services.each do |service_name, service|
    it "configures #{service_name} without a default command" do
      expect(service["command"]).to be_nil
    end
  end

  def compose_services(service_name)
    filename = File.join("services", service_name, "docker-compose.yml")
    YAML.load_file(filename)["services"]
  end
end
