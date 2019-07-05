require "spec_helper"
require_relative "../../lib/setup/docker"

describe Setup::Docker do
  let(:shell_double) { double }

  subject { described_class.new(shell_double) }
  before { allow(subject).to receive(:puts) }

  context "disallowing the script to continue" do
    it "shouldn't do anything" do
      expect(subject).to receive(:puts).with(/This will install Docker/)
      expect(shell_double).to receive(:yes?).and_return(false)
      expect(subject).to_not receive(:system)
      subject.call
    end
  end

  context "allowing the script to continue" do
    before do
      allow(shell_double).to receive(:yes?).and_return(true)
      allow(subject).to receive(:system).with("brew cask install docker")
      allow(subject).to receive(:system).with("brew install docker-compose")
      allow(subject).to receive(:puts)
    end

    context "docker dependencies are not installed" do
      it "installs docker using brew" do
        expect(subject).to receive(:puts).with(/Installing Docker/)
        expect(subject).to receive(:system).with("brew cask install docker")
        subject.call
      end

      it "installs docker-compose using brew" do
        expect(subject).to receive(:puts).with(/Installing Docker-compose/)
        expect(subject).to receive(:system).with("brew install docker-compose")
        subject.call
      end
    end
  end
end
