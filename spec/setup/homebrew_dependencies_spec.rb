require "spec_helper"
require_relative "../../lib/govuk_docker/setup/homebrew_dependencies"

describe GovukDocker::Setup::HomebrewDependencies do
  let(:shell_double) { double }

  subject { described_class.new(shell_double) }
  before do
    allow(subject).to receive(:puts)
    allow(File).to receive(:read).and_call_original
  end

  context "installing dependencies" do
    before do
      allow(subject).to receive(:system).with("brew bundle --file=#{GovukDocker::Paths.govuk_docker_dir}/Brewfile")
    end

    it "installs all the dependencies with brew" do
      expect(subject).to receive(:puts).with("Installing dependencies via Homebrew...")
      expect(subject).to receive(:system).with("brew bundle --file=#{ENV['HOME']}/govuk/govuk-docker/Brewfile")
      subject.call
    end
  end
end
