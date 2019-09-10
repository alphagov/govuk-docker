class GovukDocker::Paths
  def self.govuk_root_dir
    ENV.fetch("GOVUK_ROOT_DIR", File.join(ENV.fetch("HOME"), "govuk"))
  end

  def self.govuk_docker_dir
    ENV.fetch("GOVUK_DOCKER_DIR", File.join(govuk_root_dir, "govuk-docker"))
  end

  def self.dnsmasq_conf
    File.join(govuk_docker_dir, 'config/dnsmasq.conf')
  end
end
