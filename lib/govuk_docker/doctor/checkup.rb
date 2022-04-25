module GovukDocker::Doctor
  class Checkup
    def initialize(service_name:, checkups:, messages:)
      @checkups = checkups
      @service_name = service_name
      @messages = messages
      @return_message = []
    end

    def call
      checkup
      generate_return_message
      return_message.join("\r\n")
    end

    def checkup
      up_to_date? if checkups.include?(:up_to_date)
      installed? if checkups.include?(:installed)
      running? if checkups.include?(:running)
      running_as_different_user? if checkups.include?(:running_as_different_user)
      dnsmasq_config? if checkups.include?(:dnsmasq_config)
      dnsmasq_resolver? if checkups.include?(:dnsmasq_resolver)
      dnsmasq_resolving? if checkups.include?(:dnsmasq_resolving)
    end

    def up_to_date?
      @up_to_date ||= system "git -C #{GovukDocker::Paths.govuk_docker_dir} diff main origin/main --exit-code --quiet"
    end

    def installed?
      # some people don't have /usr/local/sbin in their PATH
      @installed ||= system("which #{service_name} 1>/dev/null") \
                       || File.exist?("/usr/local/sbin/#{service_name}")
    end

    def running?
      @running ||= system "pgrep #{service_name} 1>/dev/null"
    end

  private

    attr_reader :checkups, :service_name, :messages
    attr_accessor :return_message

    def generate_return_message
      up_to_date_state_message if checkups.include?(:up_to_date)
      install_state_message if checkups.include?(:installed)
      run_state_message if checkups.include?(:running)
      running_user_message if checkups.include?(:running_as_different_user)
      dnsmasq_config_message if checkups.include?(:dnsmasq_config)
      dnsmasq_resolver_message if checkups.include?(:dnsmasq_resolver)
      dnsmasq_resolving_message if checkups.include?(:dnsmasq_resolving)
    end

    def up_to_date_state_message
      return_message << if up_to_date?
                          messages[:up_to_date]
                        else
                          messages[:outdated]
                        end
    end

    def install_state_message
      return_message << if installed?
                          messages[:installed]
                        else
                          messages[:not_installed]
                        end
    end

    def run_state_message
      return_message << if running?
                          messages[:running]
                        else
                          messages[:not_running]
                        end
    end

    def running_as_different_user?
      @running_as_different_user ||= running? && !system("pgrep -u `whoami` #{service_name} 1>/dev/null")
    end

    def running_user_message
      return_message << if running_as_different_user?
                          messages[:running_as_different_user]
                        else
                          messages[:not_running_as_different_user]
                        end
    end

    def dnsmasq_config?
      brew_prefix = `brew --prefix`.strip
      File.exist?("#{brew_prefix}/etc/dnsmasq.conf") &&
        File.exist?("#{brew_prefix}/etc/dnsmasq.d/development.conf")
    end

    def dnsmasq_config_message
      return_message << if dnsmasq_config?
                          messages[:dnsmasq_config]
                        else
                          messages[:not_dnsmasq_config]
                        end
    end

    def dnsmasq_resolver?
      File.read("/etc/resolver/dev.gov.uk").strip == "nameserver 127.0.0.1\nport 53"
    end

    def dnsmasq_resolver_message
      return_message << if dnsmasq_resolver?
                          messages[:dnsmasq_resolver]
                        else
                          messages[:not_dnsmasq_resolver]
                        end
    end

    def dnsmasq_resolving?
      `dig +short +time=1 +tries=1 app.dev.gov.uk @127.0.0.1`.strip == "127.0.0.1"
    end

    def dnsmasq_resolving_message
      return_message << if dnsmasq_resolving?
                          messages[:dnsmasq_resolving]
                        else
                          messages[:not_dnsmasq_resolving]
                        end
    end
  end
end
