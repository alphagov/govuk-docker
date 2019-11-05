require "spec_helper"

RSpec.describe "Make dependencies" do
  Dir.glob("*", base: "services").each do |service_name|
    it "mirrors docker-compose.yml for #{service_name}" do
      expect(compose_dependencies(service_name))
        .to match_array(makefile_dependencies(service_name))
    end
  end

  def compose_dependencies(service_name)
    filename = compose_file(service_name)
    service_stacks = YAML.load_file(filename)["services"].values
    dependencies = service_stacks.flat_map { |s| s["depends_on"].to_a }
    dependencies = compose_remove_stack_from_service_name(dependencies)
    (dependencies & makeable_app_services) - [service_name]
  end

  def makefile_dependencies(service_name)
    filename = make_file(service_name)
    return [] unless File.exist?(filename)

    targets = File.readlines(filename).first.scan(/[\w\-_]+/)
    (targets & makeable_app_services) - [service_name]
  end

  def compose_remove_stack_from_service_name(dependencies)
    dependencies.map { |d| d.sub(/\-\w+$/, "").sub(/-app$/, "") }
  end

  def makeable_app_services
    @makeable_app_services ||= service_names.select do |service_name|
      File.exist?(make_file(service_name)) &&
        File.read(compose_file(service_name)) =~ /#{service_name}-app/
    end
  end

  def service_names
    @service_names ||= Dir.glob("*", base: "services")
  end

  def compose_file(service_name)
    File.join("services", service_name, "docker-compose.yml")
  end

  def make_file(service_name)
    File.join("services", service_name, "Makefile")
  end
end
