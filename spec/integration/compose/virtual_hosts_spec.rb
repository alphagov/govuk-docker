require "spec_helper"

RSpec.describe "Compose virtual hosts" do
  ComposeHelper.app_services.each do |service_name, service|
    it "configures #{service_name} to depend on nginx-proxy" do
      expect(service["depends_on"]).to include("nginx-proxy")
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
    @compose_nginx_domains ||= YAML.load_file("docker-compose.yml")
      .dig("services", "nginx-proxy", "networks", "default", "aliases")
  end
end
