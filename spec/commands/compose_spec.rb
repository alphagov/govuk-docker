require "spec_helper"
require_relative "../../lib/commands/compose"

describe Commands::Compose do
  let(:config_directory) { "spec/fixtures" }
  let(:verbose) { nil }

  subject { described_class.new(config_directory: config_directory, verbose: verbose) }

  before do
    allow(subject).to receive(:puts)
    allow(subject).to receive(:system) { 0 }
  end

  context "when in verbose mode" do
    let(:verbose) { true }
    it "calls docker-compose with the correct configure files and arguments" do
      expect(subject).to receive(:system).with(
        "docker-compose",
        "-f", "spec/fixtures/docker-compose.yml",
        "-f", "spec/fixtures/services/example-service/docker-compose.yml",
        "-f", "spec/fixtures/services/nginx-proxy/docker-compose.yml",
        "fake args"
      )

      subject.call(["fake args"])
    end

    it "outputs the full list of docker compose files" do
      expect(subject).to receive(:system).with(
        "docker-compose",
        "-f", "spec/fixtures/docker-compose.yml",
        "-f", "spec/fixtures/services/example-service/docker-compose.yml",
        "-f", "spec/fixtures/services/nginx-proxy/docker-compose.yml",
        "test args"
      )

      expect(subject).to receive(:puts)
        .with("docker-compose -f spec/fixtures/docker-compose.yml -f spec/fixtures/services/example-service/docker-compose.yml -f spec/fixtures/services/nginx-proxy/docker-compose.yml test args")

      subject.call(["test args"])
    end
  end

  context "when in silent mode" do
    let(:verbose) { false }
    it "outputs a truncated list of docker compose files" do
      expect(subject).to receive(:system).with(
        "docker-compose",
        "-f", "spec/fixtures/docker-compose.yml",
        "-f", "spec/fixtures/services/example-service/docker-compose.yml",
        "-f", "spec/fixtures/services/nginx-proxy/docker-compose.yml",
        "test args"
      )

      expect(subject).to receive(:puts).with("docker-compose -f [...] test args")
      subject.call(["test args"])
    end
  end
end
