require "spec_helper"
require_relative "../../lib/govuk_docker/commands/startup"

describe Commands::Startup do
  let(:config_directory) { "spec/fixtures" }

  subject { described_class.new(config_directory: config_directory, service: "example-service") }

  let(:run_double) { instance_double(Commands::Run) }
  before { allow(run_double).to receive(:call) }

  before do
    allow(Thread).to receive(:new).and_yield # to run the thread in the current context
    allow(subject).to receive(:wait_until_can_visit?).and_return(true)
    allow(subject).to receive(:puts)
  end

  context "without a variation" do
    it "calls `Run` in the correct stack" do
      expect(Commands::Run).to receive(:new).with(a_hash_including(stack: "app")).and_return(run_double)
      subject.call
    end
  end

  context "with a variation" do
    it "calls `Run` in the correct stack" do
      expect(Commands::Run).to receive(:new).with(a_hash_including(stack: "app-e2e")).and_return(run_double)
      subject.call("e2e")
    end
  end

  it "prints the URL of the app" do
    expect(Commands::Run).to receive(:new).with(a_hash_including(stack: "app")).and_return(run_double)
    expect(subject).to receive(:wait_until_can_visit?).and_return(true)
    expect(subject).to receive(:puts).with("\e[0;34;49mApplication is available at: http://example_service.dev.gov.uk\e[0m")
    subject.call
  end
end
