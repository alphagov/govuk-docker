require "spec_helper"
require_relative "../../lib/commands/build"
require_relative "../../lib/errors/unknown_service"

describe Commands::Build do
  let(:config_directory) { "spec/fixtures" }
  let(:service) { nil }

  subject { described_class.new(config_directory, service) }

  context "when a service exists" do
    let(:service) { "example-service" }

    it "should run docker compose" do
      expect(subject).to receive(:system).with("make", "-f", "#{config_directory}/Makefile", "example-service")
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
