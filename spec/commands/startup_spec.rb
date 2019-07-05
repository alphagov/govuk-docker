require "spec_helper"
require_relative "../../lib/commands/startup"

describe Commands::Startup do
  subject { described_class.new }

  let(:run_double) { instance_double(Commands::Run) }
  before { allow(run_double).to receive(:call) }

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
end
