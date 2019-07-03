require_relative "../doctor/dnsmasq"

module Install
  class Dnsmasq
    def call
      install_dnsmasq
      configure_etc_resolver_devgovuk
      configure_usr_local_etc_dnsmasq
      configure_usr_local_etc_dnsmasq_developmentconf
      restart_dnsmasq
      verify_dns
      puts "✅ Dnsmasq installation and configuration complete!"
    end

  private

    def install_dnsmasq
      return if Doctor::Dnsmasq.new.installed?

      puts "⏳ Installing dnsmasq"
      system("brew install dnsmasq")
    end

    def configure_etc_resolver_devgovuk
    end

    def configure_usr_local_etc_dnsmasq
    end

    def configure_usr_local_etc_dnsmasq_developmentconf
    end

    def restart_dnsmasq
    end

    def verify_dns
    end
  end
end
