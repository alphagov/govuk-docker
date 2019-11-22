require "spec_helper"

RSpec.describe "Make dependencies" do
  ServicesHelper.names.each do |service_name|
    it "mirrors docker-compose.yml for #{service_name}" do
      expect(compose_dependencies(service_name))
        .to match_array(makefile_dependencies(service_name))
    end
  end

  def compose_dependencies(service_name)
    service_stacks = ComposeHelper.services(service_name).values
    dependencies = service_stacks.flat_map { |s| s["depends_on"].to_a }
    dependencies = compose_remove_stack_from_service_name(dependencies)
    (dependencies & ServicesHelper.names) - [service_name]
  end

  def makefile_dependencies(service_name)
    MakefileHelper.dependencies(service_name) &
      compose_remove_stack_from_service_name(ComposeHelper.app_services.keys)
  end

  def compose_remove_stack_from_service_name(dependencies)
    dependencies.map { |d| d.sub(/\-\w+$/, "").sub(/-app$/, "") }
  end
end
