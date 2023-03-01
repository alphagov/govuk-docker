require "spec_helper"

RSpec.describe "Make dependencies" do
  # Some dependencies are only needed by the dependant app for their static files - for example, schemas in publishing api.
  let(:dependencies_that_do_not_need_to_be_running) { %w[publishing-api] }

  ProjectsHelper.all_projects.each do |project_name|
    it "mirrors docker-compose.yml for #{project_name}" do
      expect(app_dependencies_in_compose_file(project_name))
        .to match_array(app_dependencies_in_makefile(project_name))
    end

    it "has only valid dependencies in the #{project_name} Makefile" do
      app_dependencies = MakefileHelper.dependencies(project_name)
        .reject { |dep| dep =~ /^(bundle|clone)/ }

      expect((app_dependencies - ProjectsHelper.all_projects)).to eq([])
    end
  end

  def app_dependencies_in_compose_file(project_name)
    project_stacks = ComposeHelper.services(project_name).values
    dependencies = project_stacks.flat_map { |s| s["depends_on"].to_a }
    dependencies = compose_remove_stack_from_service_name(dependencies)
    app_dependencies = (dependencies & ProjectsHelper.all_projects) - [project_name]
    app_dependencies - dependencies_that_do_not_need_to_be_running
  end

  def app_dependencies_in_makefile(project_name)
    app_dependencies = MakefileHelper.dependencies(project_name) &
      compose_remove_stack_from_service_name(ComposeHelper.app_services.keys)
    app_dependencies - dependencies_that_do_not_need_to_be_running
  end

  def compose_remove_stack_from_service_name(dependencies)
    dependencies.map { |d| d.sub(/-\w+$/, "").sub(/-app$/, "") }
  end
end
