require "spec_helper"
require_relative "../../lib/commands/build"
require_relative "../../lib/errors/unknown_service"

describe Commands::Build do
  let(:config_directory) { "spec/fixtures" }
  let(:service) { nil }
  let(:system) { double(:system, call: true) }

  subject { described_class.new(service, config_directory, system) }

  context "when a service exists" do
    let(:service) { "example-service" }
    let(:compose_command) { instance_double Commands::Compose, call: true }
    let(:prune_command) { instance_double Commands::Prune, call: true }

    before { expect(Commands::Compose).to receive(:new).and_return(compose_command) }
    before { expect(Commands::Prune).to receive(:new).and_return(prune_command) }

    it "should run make for the service" do
      expect(system).to receive(:call).with("make", "-f", "#{config_directory}/Makefile", "example-service")
      subject.call
    end

    it "should cleanup after itself" do
      expect(compose_command).to receive(:call).with("stop")
      expect(prune_command).to receive(:call)
      subject.call
    end
  end

  context "when a service doesn't exist" do
    let(:service) { "no-example-service" }

    it "should fail" do
      expect { subject.call }.to raise_error(UnknownService)
    end
  end
end
