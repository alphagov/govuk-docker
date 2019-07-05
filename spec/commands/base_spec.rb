require "spec_helper"
require_relative "../../lib/govuk_docker/commands/base"

describe Commands::Base do
  subject { described_class.new }

  describe "#system_command" do
    it "runs a given system command" do
      expect(subject).to receive(:system).with("arg") { true }
      subject.system_command("arg")
    end

    it "raises for non-zero exit codes" do
      allow(subject).to receive(:system)
      expect { subject.system_command }.to raise_error("Non-zero exit code")
    end
  end
end
