require "spec_helper"

RSpec.describe "Compose virtual hosts" do
  compose_files = Dir.glob("services/**/docker-compose.yml")

  compose_app_services = compose_files.flat_map do |filename|
    YAML.load_file(filename)["services"].to_a.select do |service_name, _service|
      next false if service_name == "nginx-proxy-app"
      service_name =~ /app(-\w+)?$/
    end
  end

  compose_app_services.each do |service_name, service|
    it "configures #{service_name} to depend on nginx-proxy" do
      expect(service["depends_on"]).to include("nginx-proxy-app")
    end

    it "configures #{service_name} to define a VIRTUAL_HOST" do
      expect(service["environment"].keys).to include("VIRTUAL_HOST")
    end

    it "configures #{service_name} to expose a default port" do
      expect(service["expose"].to_a.count).to be > 0

      if service["expose"].count > 1
        expect(service["environment"].keys).to include("VIRTUAL_PORT")
      end
    end

    it "configures nginx-proxy for #{service_name} domains" do
      domains = service.dig("environment", "VIRTUAL_HOST")
        .to_s.gsub(/\s+/, "").split(",")

      expect(compose_nginx_domains).to include(*domains)
    end
  end

  def compose_nginx_domains
    filename = "services/nginx-proxy/docker-compose.yml"

    @compose_nginx_domains ||= YAML.load_file(filename)
      .dig("services", "nginx-proxy-app", "networks", "default", "aliases")
  end
end
