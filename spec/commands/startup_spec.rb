require "spec_helper"
require_relative "../../lib/govuk_docker/commands/startup"

describe GovukDocker::Commands::Startup do
  let(:config_directory) { "spec/fixtures" }

  subject { described_class.new(config_directory: config_directory, service: "example-service") }

  let(:run_double) { instance_double(GovukDocker::Commands::Run) }
  before { allow(run_double).to receive(:call) }

  before do
    allow(subject).to receive(:puts)
  end

  context "without a variation" do
    it "calls `Run` in the correct stack" do
      expect(GovukDocker::Commands::Run).to receive(:new).with(a_hash_including(stack: "app")).and_return(run_double)
      subject.call
    end
  end

  context "with a variation" do
    it "calls `Run` in the correct stack" do
      expect(GovukDocker::Commands::Run).to receive(:new).with(a_hash_including(stack: "app-e2e")).and_return(run_double)
      subject.call("e2e")
    end
  end
end
