require 'colorize'
require 'net/http'
require 'timeout'

require_relative './base'
require_relative './run'

class GovukDocker::Commands::Startup < GovukDocker::Commands::Base
  def call(variation = nil)
    stack = variation ? "app-#{variation}" : "app"

    print_live_hostname

    GovukDocker::Commands::Run
      .new(config_directory: config_directory, service: service, stack: stack, verbose: verbose)
      .call
  end

private

  def print_live_hostname
    return unless hostname

    Thread.new do
      url = "http://#{hostname}"

      Timeout::timeout(30) do
        wait_until_can_visit?(url)

        puts
        puts "Application is available at: #{url}".blue
        puts "\n\r"
      end
    rescue Timeout::Error
      puts
      puts "Warning: Unable to communicate with application within 30 seconds.".red
      puts "\n\r"
    end
  end

  def possible_hostnames
    path = File.join(config_directory, "services", "nginx-proxy", "docker-compose.yml")
    docker_compose = YAML.load_file(path)
    docker_compose["services"]["nginx-proxy-app"]["networks"]["default"]["aliases"]
  end

  def find_hostname
    search_hostname = "#{service.tr('_-', '')}.dev.gov.uk"
    possible_hostnames.each do |hostname|
      return hostname if hostname.tr('_-', '') == search_hostname
    end

    nil
  end

  def hostname
    @hostname ||= find_hostname
  end

  def wait_until_can_visit?(url)
    loop do
      sleep(1)
      break if can_visit?(url)
    end
  end

  def can_visit?(url)
    case Net::HTTP.get_response(URI(url))
    when Net::HTTPSuccess, Net::HTTPRedirection then
      true
    else
      false
    end
  rescue Errno::EHOSTDOWN, Errno::ECONNREFUSED
    false
  end
end
