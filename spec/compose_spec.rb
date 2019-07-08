require "yaml"

RSpec.describe "Docker compose files" do
  it "has correctly configured the domains" do
    expect(configured_service_domains).to match_array(configured_nginx_domains)
  end

  def configured_service_domains
    domains = Dir.glob("services/**/docker-compose.yml").map do |filename|
      services = YAML.load_file(filename)["services"]
      services.map do |_service_name, opts|
        opts.dig("environment", "VIRTUAL_HOST").to_s.split(",")
      end
    end

    domains.compact.flatten.uniq
  end

  def configured_nginx_domains
    nginx_config = YAML.load_file("services/nginx-proxy/docker-compose.yml")
    nginx_config["services"]["nginx-proxy-app"]["networks"]["default"]["aliases"]
  end
end
