module GovukDocker::Doctor
  def self.messages
    {
      govuk_docker: govuk_docker_messages,
      dnsmasq: dnsmasq_messages,
      docker: docker_messages,
      docker_compose: docker_compose_messages,
    }
  end

  def self.govuk_docker_messages
    {
      up_to_date: "✅ govuk-docker is up-to-date",
      outdated: <<~HEREDOC,
        ❌ govuk-docker is outdated.
        You should pull the latest version from https://github.com/alphagov/govuk-docker/.
      HEREDOC
    }
  end

  def self.docker_messages
    {
      installed: "✅ Docker is installed",
      not_installed: <<~HEREDOC,
        ❌ Docker not found.
        You should install Docker by grabbing the latest image from https://docs.docker.com/docker-for-mac/release-notes/.
        For manual installation, visit https://docs.docker.com/install/.
      HEREDOC
      running: "✅ Docker is running",
      not_running: <<~HEREDOC,
        ❌ Docker is not running.
        Please make sure Docker is running before using govuk-docker.
      HEREDOC
    }
  end

  def self.docker_compose_messages
    {
      installed: "✅ Docker Compose is installed",
      not_installed: <<~HEREDOC,
        ❌ Docker Compose not found.
        You should install Docker by grabbing the latest image from https://docs.docker.com/docker-for-mac/release-notes/.
        For manual installation, visit https://docs.docker.com/compose/install/
      HEREDOC
    }
  end

  def self.dnsmasq_messages
    {
      installed: "✅ Dnsmasq is installed",
      not_installed: <<~HEREDOC,
        ❌ Dnsmasq not found.
        You should install it with `brew install dnsmasq`.
        For a manual installation, visit http://www.thekelleys.org.uk/dnsmasq/doc.html
      HEREDOC
      running: "✅ Dnsmasq is running",
      not_running: <<~HEREDOC,
        ❌ Dnsmasq is not running.
        Dnsmasq needs to run as root.
        You should start it with `sudo brew services start dnsmasq`.
      HEREDOC
      running_as_different_user: "✅ Dnsmasq is running as the correct user",
      not_running_as_different_user: <<~HEREDOC,
        ❌ Dnsmasq is running under your user.
        Dnsmasq needs to run as root.
        You should start it with `sudo brew services start dnsmasq`.
      HEREDOC
      dnsmasq_config: "✅ Dnsmasq config files are set up correctly",
      not_dnsmasq_config: <<~HEREDOC,
        ❌ One or more dnsmasq config files is missing.
        Try running `bin/setup` again.
      HEREDOC
      dnsmasq_resolver: "✅ Dnsmasq resolver file is set up correctly",
      not_dnsmasq_resolver: <<~HEREDOC,
        ❌ Your DNS resolver file (/etc/resolver/dev.gov.uk) has unexpected content.
        Try running `bin/setup` again.
      HEREDOC
      dnsmasq_resolving: "✅ Dnsmasq is resolving app.dev.gov.uk correctly",
      not_dnsmasq_resolving: <<~HEREDOC,
        ❌ Dnsmasq is not resolving app.dev.gov.uk correctly.
        Try running `bin/setup` again, and check system logs for dnsmasq.
      HEREDOC
    }
  end
end
