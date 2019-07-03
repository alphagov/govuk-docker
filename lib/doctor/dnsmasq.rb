module Doctor
  class Dnsmasq
    def initialize
      @message = []
    end

    def call
      install_state?
      run_state?

      message.join("\r\n")
    end

    def installed?
      system "which dnsmasq 1>/dev/null"
    end

  private

    attr_reader :message

    DNSMASQ_INSTALLED = "✅ Dnsmasq is installed".freeze
    INSTALL_DNSMASQ = <<~HEREDOC.freeze
      ❌ Dnsmasq not found.
      You should install it with `brew install dnsmasq`.
      For a manual installation, visit http://www.thekelleys.org.uk/dnsmasq/doc.html
    HEREDOC

    DNSMASQ_RUNNING = "✅ Dnsmasq is running".freeze
    START_DNSMASQ = <<~HEREDOC.freeze
      ❌ Dnsmasq is not running.
      Dnsmasq needs to run as root.
      You should start it with `sudo brew services start dnsmasq`.
    HEREDOC

    def install_state?
      message << if installed?
                   DNSMASQ_INSTALLED
                 else
                   INSTALL_DNSMASQ
                 end
    end

    def run_state?
      return unless installed?

      message << if dnsmasq_running?
                   DNSMASQ_RUNNING
                 else
                   START_DNSMASQ
                 end
    end

    def dnsmasq_running?
      system "pgrep dnsmasq 1>/dev/null"
    end
  end
end
