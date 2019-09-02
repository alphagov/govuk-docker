class GovukDocker::Stack
  attr_reader :name,
              :volumes,
              :working_dir,
              :command,
              :environment,
              :depends_on,
              :image,
              :ports

  def initialize(name, config)
    @name = name
    @volumes = config['volumes'].to_a
    @working_dir = config['working_dir']
    @command = config['command']
    @environment = config['environment'].to_h
    @depends_on = config['depends_on'].to_a
    @image = config['image']
    @ports = config['ports']
  end

  def self.all
    @all ||= config_files
      .each_with_object({}) { |path, s| s.merge!(YAML.load_file(path)) }
  end

  def self.find(name)
    raise "Service stack not found for #{name}" unless all.key?(name)
    new(name, all[name])
  end

  def self.config_files
    config_directory = GovukDocker::Paths.govuk_docker_dir
    files = Dir.glob(File.join(config_directory, "services", "*", "stacks.yml"))
    files << File.join(config_directory, "stacks.yml")
  end

  def dependencies
    depends_on
      .flat_map { |d| sub_dependencies(d) }.uniq
      .map { |d| GovukDocker::Stack.find(d) }
  end

private

  def sub_dependencies(stack_name)
    depends_on = GovukDocker::Stack.all[stack_name]['depends_on'].to_a
    return [stack_name] if depends_on.empty?
    [stack_name] + depends_on.flat_map { |d| sub_dependencies(d) }
  end
end
