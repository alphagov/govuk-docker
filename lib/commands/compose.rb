require_relative './base'

class Commands::Compose < Commands::Base
  def call(verbose, *args)
    args.insert(0, "docker-compose")
    args.insert(1, *docker_compose_args)
    verbose ? display_full_commands(args) : display_truncated_commands(args)
    system.call(*args)
  end

private

  def display_full_commands(args)
    puts args.join(" ")
  end

  def display_truncated_commands(args)
    args = args - docker_compose_args
    args.insert(1, '-f [...]')
    puts args.join(" ")
  end

  def docker_compose_args
    docker_compose_paths.flat_map { |filename| ["-f", filename] }
  end
end
