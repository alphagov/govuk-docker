require "spec_helper"

RSpec.describe "Compose rails debugger" do
  compose_files = Dir.glob("services/**/docker-compose.yml")

  rails_app_services = compose_files.flat_map do |filename|
    YAML.load_file(filename)["services"].to_a.select do |_service_name, service|
      service["command"] =~ /rails/
    end
  end

  rails_app_services.each do |service_name, service|
    it "#{service_name} supports attaching an interactive debugger" do
      expect(service["tty"]).to be_truthy
      expect(service["stdin_open"]).to be_truthy
    end
  end
end
