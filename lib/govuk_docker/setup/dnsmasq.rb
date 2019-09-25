require_relative "./base"
require_relative "../doctor/checkup"

class GovukDocker::Setup::Dnsmasq < GovukDocker::Setup::Base
  def call
    return unless check_continue

    configure_etc_resolver_devgovuk
    configure_usr_local_etc_dnsmasq
    configure_usr_local_etc_dnsmasq_developmentconf
    restart_dnsmasq
    puts "✅ Dnsmasq installation and configuration complete!"
  end

private

  def check_continue
    puts "Any local changes in these files may get overwritten by this script:"
    puts "- /etc/resolver/dev.gov.uk"
    puts "- /usr/local/etc/dnsmasq.conf"
    puts "- /usr/local/etc/dnsmasq.d/development.conf"
    puts

    unless %x[uname -a].include?("Darwin")
      puts "This script is designed to run on macOS."
      puts
    end

    shell.yes?("Are you sure you want to continue?")
  end

  def configure_etc_resolver_devgovuk
    write_file(
      "/etc/resolver/dev.gov.uk",
      File.read(GovukDocker::Paths.dnsmasq_conf),
      overwrite: true
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

  def write_file(path, contents, overwrite: false)
    return if file_configured?(path, contents) && !overwrite

    puts "⏳ Writing #{path}"
    File.write(path, "#{contents}\n")
  end

  def append_file(path, contents)
    return if file_configured?(path, contents)

    puts "⏳ Appending #{path}"
    File.open(path, "a") do |file|
      file.write("\n#{contents}\n")
    end
  end
end
