require "aws-sdk-s3"
require "ruby-progressbar"

module GovukDocker
  module Aws
    class Client
      def initialize(mfa_token)
        @client = ::Aws::S3::Client.new(credentials: role_credentials(mfa_token))
      end

      def download_bucket(bucket_name:, dest_path:)
        FileUtils.mkdir_p dest_path
        bucket = ::Aws::S3::Resource.new(client: client).bucket(bucket_name)
        progress_bar = ProgressBar.create(title: "Downloading bucket from S3", total: bucket.objects.count)

        bucket.objects.each do |content|
          download_object(content: content, bucket_name: bucket_name, dest_path: dest_path)
          progress_bar.increment
        end
      end

    private

      attr_reader :client, :config_hash

      def download_object(content:, bucket_name:, dest_path:)
        full_path = File.join(dest_path, content.key)
        dirname = File.dirname(full_path)
        FileUtils.mkdir_p dirname
        File.open(full_path, "wb") do |file|
          client.get_object(bucket: bucket_name, key: content.key) do |chunk|
            file.write(chunk)
          end
        end
      end

      def role_credentials(mfa_token)
        config_hash = ::Aws::IniParser.ini_parse(File.read(File.join(ENV["HOME"], "/.aws/config")))
        ::Aws::AssumeRoleCredentials.new(client: sts_client,
                                         role_arn: config_hash.dig("govuk-integration", "role_arn"),
                                         role_session_name: role_session_name,
                                         serial_number: config_hash.dig("govuk-integration", "mfa_serial"),
                                         token_code: mfa_token)
      end

      def sts_client(profile: "gds", region: "eu-west-1")
        ::Aws::STS::Client.new(profile: profile, region: region)
      end

      def role_session_name
        "#{ENV['USER']}-#{Time.now.strftime('%d-%m-%y_%H-%M')}"
      end
    end
  end
end
