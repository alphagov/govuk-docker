require_relative "./base"
require_relative "../paths"

class GovukDocker::Setup::Repo < GovukDocker::Setup::Base
  def call
    unless should_clone_or_pull?
      puts "Ignoring git repo because of local changes."
      return
    end

    return unless check_continue

    clone_or_pull

    puts "✅ govuk-docker is up to date!"
  end

private

  def should_clone_or_pull?
    return true unless File.directory?(path)
    return false if repo_has_local_changes?

    true
  end

  def repo_has_local_changes?
    !system("git -C #{path} diff-index --quiet HEAD --")
  end

  def check_continue
    puts "This will clone/pull `#{path}`."
    puts "Any local changes may be overwritten."
    puts

    shell.yes?("Are you sure you want to continue?")
  end

  def clone_or_pull
    if File.directory?(path)
      pull
    else
      clone
    end
  end

  def pull
    system("git -C #{path} pull")
  end

  def clone
    system("git clone https://github.com/alphagov/govuk-docker.git #{path}")
  end

  def path
    GovukDocker::Paths.govuk_docker_dir
  end
end
