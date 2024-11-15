require "spec_helper"

RSpec.describe "Expected volumes" do
  def self.rails_projects
    rails_service_names = ComposeHelper.rails_app_services.keys

    ProjectsHelper.all_projects.select do |project_name|
      project_service_names = ComposeHelper.services(project_name).keys
      rails_service_names.intersection(project_service_names).any?
    end
  end

  def self.node_projects
    ProjectsHelper.all_projects.select do |project_name|
      makefile = File.read("projects/#{project_name}/Makefile")
      makefile.match(/yarn|npm/)
    end
  end

  rails_projects.each do |project_name|
    ComposeHelper.services(project_name)
                 .reject { |service_name| service_name.end_with? "redis" }
                 .each_pair do |service_name, service|
      it "configures #{service_name} with a govuk delegated volume" do
        expect(service.fetch("volumes", []))
          .to include("${GOVUK_ROOT_DIR:-~/govuk}:/govuk:delegated")
      end

      it "configures #{service_name} with a root-home volume" do
        expect(service.fetch("volumes", [])).to include("root-home:/root")
      end

      it "configures #{service_name} with a tmp volume" do
        expect(service.fetch("volumes", []))
          .to include("#{project_name}-tmp:/govuk/#{project_name}/tmp")
      end
    end
  end

  node_projects.each do |project_name|
    ComposeHelper.services(project_name)
                 .reject { |service_name| service_name.end_with? "redis" }
                 .each_pair do |service_name, service|
      it "configures #{service_name} with a node modules volume" do
        expect(service.fetch("volumes", []))
          .to include("#{project_name}-node-modules:/govuk/#{project_name}/node_modules")
      end
    end
  end
end
