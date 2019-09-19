require "elasticsearch-ruby"
require_relative "../../../lib/govuk_docker"
require_relative "../../../lib/govuk_docker/cli"

module GovukDocker
  module Elasticsearch
    class Client
      def initialize(snapshot_directory:,
                     service:)
        @snapshot_directory = snapshot_directory
        @service = service
        @elasticsearch_client = ::Elasticsearch::Client.new transport_options: { request: { timeout: 20 * 60 } }
      end

      def wait_for_elasticsearch
        print "starting elasticsearch"
        begin
          elasticsearch_client.cat.health
          puts; puts "elasticsearch is up and running"
        rescue StandardError
          retries ||= 0
          print "."
          sleep 2
          retry if (retries += 1) < 20
          puts "elasticsearch cannot be reached"
        end
      end

      def start_elasticsearch
        FileUtils.mkdir_p snapshot_directory
        GovukDocker::Commands::Compose.new.call(
          [
            "run",
            "-d",
            "--rm",
            "-p", "9200:9200",
            "-v",
            "#{File.join(File.dirname(__FILE__), '../../../elasticsearch_import.yml')}:/usr/share/elasticsearch/config/elasticsearch.yml",
            "-v",
            "#{snapshot_directory}:/replication",
            service
          ],
        )
      end

      def restore(snapshot_name)
        puts "restoring snapshot..."
        elasticsearch_client.indices.delete(index: "_all")
        elasticsearch_client.snapshot.restore(repository: "snapshots", snapshot: snapshot_name, wait_for_completion: true)
        elasticsearch_client.indices.put_settings body: { index: { number_of_replicas: 0 } }
      end

      def snapshot
        elasticsearch_client.snapshot.create_repository(repository: "snapshots",
                                                        body: {
                                                          type: "fs",
                                                          settings: {
                                                            location: "/replication",
                                                            compress: true,
                                                            readonly: true,
                                                          },
                                                        })
        all_snapshots = elasticsearch_client.snapshot.get(repository: "snapshots", snapshot: "_all")
        all_snapshots.fetch("snapshots").map { |s| s.fetch("snapshot") }.max
      end

      def remove_snapshot
        elasticsearch_client.snapshot.delete_repository repository: "snapshots"
      end

    private

      attr_reader :environment, :snapshot_directory, :service,
                  :skip_download, :skip_remove_download, :elasticsearch_client
    end
  end
end
