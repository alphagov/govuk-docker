require_relative './base'

class Commands::Compose < Commands::Base
  def call(*args)
    args.insert(0, "docker-compose")
    args.insert(1, *docker_compose_args)
    puts args.join(" ")
    system.call(*args)
  end

private

  def docker_compose_args
    docker_compose_paths.flat_map { |filename| ["-f", filename] }
  end
end
