require "spec_helper"

RSpec.describe "Compose rails debugger" do
  compose_files = Dir.glob("services/**/docker-compose.yml")

  compose_app_services = compose_files.flat_map do |filename|
    YAML.load_file(filename)["services"].to_a.select do |service_name, _service|
      service_name =~ /app(-\w+)?$/
    end
  end

  compose_app_services.each do |service_name, service|
    it "#{service_name} supports attaching an interactive debugger" do
      expect(service["tty"]).to be_truthy
      expect(service["stdin_open"]).to be_truthy
    end
  end
end
