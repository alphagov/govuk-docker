module ProjectsHelper
  def self.all_projects
    Dir.glob("*", base: "projects")
  end
end
