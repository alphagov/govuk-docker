module Doctor
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
      installed? if checkups.include?(:installed)
      running? if checkups.include?(:running)
      running_as_different_user? if checkups.include?(:running_as_different_user)
    end

    def installed?
      @installed ||= system "which #{service_name} 1>/dev/null"
    end

    def running?
      @running ||= system "pgrep #{service_name} 1>/dev/null"
    end

  private

    attr_reader :checkups, :service_name, :messages
    attr_accessor :return_message

    def generate_return_message
      install_state_message if checkups.include?(:installed)
      run_state_message if checkups.include?(:running)
      running_user_message if checkups.include?(:running_as_different_user)
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
  end
end
