require_relative './base'

class GovukDocker::Commands::Prune < GovukDocker::Commands::Base
  def call
    commands.each { |command| system_command command }
  end

private

  def commands
    [
      "docker container prune -f",
      "docker volume rm $(docker volume ls -q -f 'dangling=true' | grep -x '.\{64,\}') 2> /dev/null || true",
      "docker image prune -f"
    ]
  end
end
