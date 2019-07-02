require "spec_helper"
require_relative "../../lib/commands/build_this"

describe Commands::BuildThis do
  let(:config_directory) { "spec/fixtures" }
  let(:service) { nil }

  subject { described_class.new(service, config_directory) }

  context "when a service exists" do
    let(:service) { "example-service" }

    let(:compose_command) { double }
    before { expect(Commands::Compose).to receive(:new).and_return(compose_command) }

    it "should run docker compose when a service exists" do
      expect(compose_command).to receive(:call).with("build", "example-service-default")
      subject.call
    end
  end

  context "when a service doesn't exist" do
    let(:service) { "no-example-service" }

    it "should fail" do
      expect { subject.call }.to raise_error(/Unknown service/)
    end
  end
end
