class GovukDocker::Container
  extend Forwardable

  attr_reader :stack

  def initialize(stack)
    @stack = stack
  end

  def_delegators :@stack,
                 :volumes,
                 :environment,
                 :ports,
                 :working_dir,
                 :command,
                 :image

  def running?
    `docker ps`.include?("#{stack.name}_1")
  end

  def exists?
    return true if running?
    `docker ps -a`.include?("#{stack.name}_1")
  end

  def create
    return if exists?
    name = "#{stack.name}_1"
    docker_command = %w(docker create) + docker_args(name)
    system(docker_command.join(" "))
  end

  def start
    create unless exists?
    return if running?
    system("docker start #{stack.name}_1")
  end

  def run(extra_args: [])
    name = "#{stack.name}_#{object_id}"
    docker_command = %w(docker run -it) + docker_args(name) + extra_args
    system(docker_command.join(" "))
  end

  def docker_args(name)
    args = []
    volumes.each { |v| args << "-v"; args << v }
    environment.each { |k, v| args << "-e"; args << "#{k}=#{v}" }
    ports.to_a.each { |p| args << "-p"; args << p }
    args += ["-w", working_dir] if working_dir
    args += ["--name", name]
    args << image
    args << command if command
    args
  end
end
