require "spec_helper"
require_relative "../../lib/commands/build"

describe Commands::Build do
  let(:config_directory) { "spec/fixtures" }
  let(:service) { nil }
  let(:system) { double(:system) }

  subject { described_class.new(service, config_directory, system) }

  context "when a service exists" do
    let(:service) { "example-service" }

    it "should run docker compose when a service exists" do
      expect(system).to receive(:call).with("make", "-f", "#{config_directory}/Makefile", "example-service")
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
