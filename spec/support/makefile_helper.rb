module MakefileHelper
  def self.dependencies(project_name)
    filename = File.join("projects", project_name, "Makefile")
    rule = File.readlines(filename).first
    dependencies_string = rule.split(":")[1]
    dependencies_string.scan(/[^\s]+/)
  end
end
