require_relative "./base"
require_relative "../doctor/checkup"

class GovukDocker::Setup::Dnsmasq < GovukDocker::Setup::Base
  def call
    return unless check_continue

    install_dnsmasq
    configure_etc_resolver_devgovuk
    configure_usr_local_etc_dnsmasq
    configure_usr_local_etc_dnsmasq_developmentconf
    restart_dnsmasq
    puts "✅ Dnsmasq installation and configuration complete!"
  end

private

  def check_continue
    puts "Any local changes in these files may get overwriten by this script:"
    puts "- /etc/resolver/dev.gov.uk"
    puts "- /usr/local/etc/dnsmasq.conf"
    puts "- /usr/local/etc/dnsmasq.d/development.conf"
    puts

    unless %x[uname -a].include?("Darwin")
      puts "This script is designed to run on MacOS."
      puts
    end

    shell.yes?("Are you sure you want to continue?")
  end

  def check_continue_as_sudo
    puts
    puts "🚨 This script needs to write to the following as sudo:"
    puts "- /etc/resolver/dev.gov.uk"
    puts
    puts "You will be asked for your password if you continue."
    puts
    puts "If this makes you uncomfortable, you should manually"
    puts "create the file and its contents after the rest of the script finishes."
    puts " echo \"nameserver 127.0.0.1\" >> /etc/resolver/dev.gov.uk"
    puts "should do the trick."
    puts

    shell.yes?("Are you sure you want to allow the script to create /etc/resolver/dev.gov.uk as sudo?")
  end

  def install_dnsmasq
    return if GovukDocker::Doctor::Checkup.new(
      service_name: "dnsmasq",
      checkups: %i(installed),
      messages: {}
    ).installed?

    puts "⏳ Installing dnsmasq"
    system("brew install dnsmasq")
  end

  def configure_etc_resolver_devgovuk
    write_file(
      "/etc/resolver/dev.gov.uk",
      "nameserver 127.0.0.1",
      true
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

  def write_file(path, contents, as_sudo = false)
    return if file_configured?(path, contents)

    if as_sudo
      return unless check_continue_as_sudo
    end

    ensure_directory_exists(path, as_sudo)

    puts "⏳ Writing #{path}"

    if as_sudo
      system("echo \"#{contents}\n\" | sudo tee #{path}")
    else
      File.write(path, "#{contents}\n")
    end
  end

  def append_file(path, contents)
    return if file_configured?(path, contents)

    puts "⏳ Appending #{path}"
    File.open(path, 'a') do |file|
      file.write("\n#{contents}\n")
    end
  end

  def ensure_directory_exists(path, as_sudo = false)
    dir = File.dirname(path)
    return if Dir.exist?(dir)

    puts "⏳ Creating directory #{dir}, you may need to enter your root password"

    if as_sudo
      system "sudo mkdir #{dir}"
    else
      Dir.mkdir(dir) unless as_sudo
    end
  end
end
