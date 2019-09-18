require "spec_helper"
require_relative "../../lib/govuk_docker/setup/homebrew_dependencies"

describe GovukDocker::Setup::HomebrewDependencies do
  let(:shell_double) { double }

  subject { described_class.new(shell_double) }
  before do
    allow(subject).to receive(:puts)
    allow(File).to receive(:read).and_call_original
  end

  context "disallowing the script to continue" do
    it "shouldn't do anything" do
      expect(subject).to receive(:puts).with(/This will install all the dependencies via Homebrew./)
      expect(shell_double).to receive(:yes?).and_return(false)
      expect(GovukDocker::Doctor::Checkup).to_not receive(:new)
      expect(File).to_not receive(:read)
      expect(subject).to_not receive(:system)
      subject.call
    end
  end

  context "allowing the script to continue" do
    before do
      allow(shell_double).to receive(:yes?).and_return(true)
      allow(subject).to receive(:system).with("brew bundle --file=#{GovukDocker::Paths.govuk_docker_dir}/Brewfile")
    end

    it "installs all the dependencies with brew" do
      expect(subject).to receive(:system).with("brew bundle --file=#{ENV["HOME"]}/govuk/govuk-docker/Brewfile")
      subject.call
    end
  end
end
