require "thor"
require_relative "../doctor/dnsmasq"

module Install
  class Dnsmasq
    def call
      check_macos
      install_dnsmasq
      configure_etc_resolver_devgovuk
      configure_usr_local_etc_dnsmasq
      configure_usr_local_etc_dnsmasq_developmentconf
      restart_dnsmasq
      puts "✅ Dnsmasq installation and configuration complete!"
    end

  private

    def macos?
      %x[uname -a].include?("Darwin")
    end

    def check_macos
      return if macos?

      puts "This script currently only works on MacOS."
      puts "Are you sure you want to continue?"
      Thor::Shell::Basic.new.yes?
    end

    def install_dnsmasq
      return if Doctor::Dnsmasq.new.installed?

      puts "⏳ Installing dnsmasq"
      system("brew install dnsmasq")
    end

    def configure_etc_resolver_devgovuk
      write_file(
        "/etc/resolver/dev.gov.uk",
        "nameserver 127.0.0.1"
      )
    end

    def configure_usr_local_etc_dnsmasq
      append_file(
        "/usr/local/etc/dnsmasq.conf",
        "conf-dir=/usr/local/etc/dnsmasq.d,*.conf"
      )
    end

    def configure_usr_local_etc_dnsmasq_developmentconf
      write_file(
        "/usr/local/etc/dnsmasq.d/development.conf",
        "address=/dev.gov.uk/127.0.0.1"
      )
    end

    def restart_dnsmasq
      puts "♻️  Restarting dnsmasq, you may need to enter your root password..."
      system("sudo brew services restart dnsmasq")
    end

    def file_configured?(path, contents)
      File.read(path).include?(contents)
    rescue Errno::ENOENT
      false
    end

    def write_file(path, contents)
      return if file_configured?(path, contents)

      puts "⏳ Writing #{path}"
      File.write(path, "#{contents}\n")
    end

    def append_file(path, contents)
      return if file_configured?(path, contents)

      puts "⏳ Appending #{path}"
      File.open(path, 'a') do |file|
        file.write("\n#{contents}\n")
      end
    end
  end
end
