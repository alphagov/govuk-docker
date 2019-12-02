module MakefileHelper
  def self.dependencies(service_name)
    filename = File.join("services", service_name, "Makefile")
    rule = File.readlines(filename).first
    dependencies_string = rule.split(":")[1]
    dependencies_string.scan(/[^\s]+/)
  end
end
