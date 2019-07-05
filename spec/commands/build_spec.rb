require "spec_helper"
require_relative "../../lib/govuk_docker/commands/build"
require_relative "../../lib/govuk_docker/errors/unknown_service"

describe Commands::Build do
  let(:config_directory) { "spec/fixtures" }
  let(:service) { nil }

  subject { described_class.new(config_directory: config_directory, service: service) }

  before do
    allow(subject).to receive(:system) { 0 }
  end

  context "when a service exists" do
    let(:service) { "example-service" }

    it "should make the service" do
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
