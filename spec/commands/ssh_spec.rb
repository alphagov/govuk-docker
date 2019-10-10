require "spec_helper"
require_relative "../../lib/govuk_docker/commands/startup"

describe GovukDocker::Commands::Ssh do
  let(:config_directory) { "spec/fixtures" }

  subject { described_class.new(config_directory: config_directory, service: "example-service") }

  let(:compose_command) { double }

  before do
    allow(subject).to receive(:puts)

    expect(GovukDocker::Commands::Compose).to receive(:new)
      .with(a_hash_including(config_directory: config_directory)).and_return(compose_command)
  end

  context "without a variation" do
    it "ssh's into the correct stack" do
      expect(compose_command).to receive(:call).with(%w[exec example-service-app /bin/bash])
      subject.call
    end
  end

  context "with a variation" do
    it "ssh's into the specified stack" do
      expect(compose_command).to receive(:call).with(%w[exec example-service-e2e /bin/bash])
      subject.call("e2e")
    end
  end
end
