require "spec_helper"

RSpec.describe "Make dependencies" do
  # rubocop:disable Lint/ConstantDefinitionInBlock
  # Some dependencies are only needed by the dependant app for their static files.
  DEPENDENCIES_THAT_DO_NOT_NEED_TO_BE_RUNNING = %w[govuk-content-schemas].freeze
  # rubocop:enable Lint/ConstantDefinitionInBlock

  ProjectsHelper.all_projects.each do |project_name|
    it "mirrors docker-compose.yml for #{project_name}" do
      expect(app_dependencies_in_compose_file(project_name))
        .to match_array(app_dependencies_in_makefile(project_name))
    end
  end

  def app_dependencies_in_compose_file(project_name)
    project_stacks = ComposeHelper.services(project_name).values
    dependencies = project_stacks.flat_map { |s| s["depends_on"].to_a }
    dependencies = compose_remove_stack_from_service_name(dependencies)
    app_dependencies = (dependencies & ProjectsHelper.all_projects) - [project_name]
    app_dependencies - DEPENDENCIES_THAT_DO_NOT_NEED_TO_BE_RUNNING
  end

  def app_dependencies_in_makefile(project_name)
    app_dependencies = MakefileHelper.dependencies(project_name) &
      compose_remove_stack_from_service_name(ComposeHelper.app_services.keys)
    app_dependencies - DEPENDENCIES_THAT_DO_NOT_NEED_TO_BE_RUNNING
  end

  def compose_remove_stack_from_service_name(dependencies)
    dependencies.map { |d| d.sub(/-\w+$/, "").sub(/-app$/, "") }
  end
end
