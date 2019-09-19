require "forwardable"
require "highline"
require_relative "../../../../lib/govuk_docker/aws/client"
require_relative "../../../../lib/govuk_docker/elasticsearch/client"

module GovukDocker
  module Commands
    module DataSync
      class Elasticsearch < GovukDocker::Commands::Base
        extend Forwardable

        def_delegators :@govuk_elasticsearch_client, :start_elasticsearch, :wait_for_elasticsearch, :snapshot

        def initialize(snapshot_directory:,
                       service:,
                       skip_download:,
                       skip_restore:,
                       keep_download:)
          @service = service
          @skip_download = skip_download
          @keep_download = keep_download
          @skip_restore = skip_restore
          @snapshot_directory = snapshot_directory
          @bucket_name = "govuk-integration-#{service}-manual-snapshots"
          @govuk_elasticsearch_client = GovukDocker::Elasticsearch::Client.new(snapshot_directory: snapshot_directory,
                                                                               service: service)
        end

        def sync_data
          validate!
          fetch_s3_client
          stop_all_containers
          start_elasticsearch
          wait_for_elasticsearch
          download_bucket
          restore snapshot
          remove_snapshot
          stop_elasticsearch
          remove_snapshot_directory
        end

      private

        attr_reader :govuk_s3_client, :govuk_elasticsearch_client, :keep_download, :skip_download,
                    :skip_restore, :snapshot_directory, :bucket_name, :service

        def validate!
          raise "Not a valid elasticsearch service" unless service.start_with?("elasticsearch")
        end

        def fetch_s3_client
          return if skip_download

          mfa_token = HighLine.new.ask("Enter your AWS Mfa token: ") { |q| q.echo = "." }
          @govuk_s3_client = GovukDocker::Aws::Client.new(mfa_token)
        end

        def stop_all_containers
          puts "stopping all containers"
          GovukDocker::Commands::Compose.new.call(%w[stop])
        end

        def restore(snapshot_name)
          return if skip_restore

          @govuk_elasticsearch_client.restore snapshot_name
        end

        def download_bucket
          return if skip_download

          govuk_s3_client.download_bucket(bucket_name: bucket_name, dest_path: snapshot_directory)
        end

        def stop_elasticsearch
          puts "stop elastic"
          system_command("docker stop `docker-compose ps -q #{service}`", raise_on_error: true)
        end

        def remove_snapshot
          return if skip_restore

          puts "remove repository"
          govuk_elasticsearch_client.remove_snapshot
        end

        def remove_snapshot_directory
          return if keep_download

          FileUtils.rm_rf(snapshot_directory)
        end
      end
    end
  end
end
