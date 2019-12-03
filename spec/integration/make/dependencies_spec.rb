require "spec_helper"

RSpec.describe "Make dependencies" do
  ProjectsHelper.all_projects.each do |project_name|
    it "mirrors docker-compose.yml for #{project_name}" do
      expect(compose_dependencies(project_name))
        .to match_array(makefile_dependencies(project_name))
    end
  end

  def compose_dependencies(project_name)
    project_stacks = ComposeHelper.services(project_name).values
    dependencies = project_stacks.flat_map { |s| s["depends_on"].to_a }
    dependencies = compose_remove_stack_from_service_name(dependencies)
    (dependencies & ProjectsHelper.all_projects) - [project_name]
  end

  def makefile_dependencies(project_name)
    MakefileHelper.dependencies(project_name) &
      compose_remove_stack_from_service_name(ComposeHelper.app_services.keys)
  end

  def compose_remove_stack_from_service_name(dependencies)
    dependencies.map { |d| d.sub(/\-\w+$/, "").sub(/-app$/, "") }
  end
end
