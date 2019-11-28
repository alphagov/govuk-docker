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
      dnsmasq_resolver? if checkups.include?(:dnsmasq_resolver)
    end

    def up_to_date?
      @up_to_date ||= system "git -C #{GovukDocker::Paths.govuk_docker_dir} diff master origin/master --exit-code --quiet"
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
      dnsmasq_resolver_message if checkups.include?(:dnsmasq_resolver)
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
      @running_as_different_user ||= system "ps aux | grep `pgrep #{service_name}` | grep -v `whoami` 1>/dev/null"
    end

    def running_user_message
      return_message << if running_as_different_user?
                          messages[:running_as_different_user]
                        else
                          messages[:not_running_as_different_user]
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
  end
end
