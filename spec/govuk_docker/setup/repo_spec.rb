require "spec_helper"

describe GovukDocker::Setup::Repo do
  let(:shell_double) { double }
  let(:path) { "/home/test/govuk/govuk-docker" }

  around do |example|
    ClimateControl.modify(GOVUK_DOCKER_DIR: path) do
      example.run
    end
  end

  subject { described_class.new(shell_double) }

  before do
    allow(subject).to receive(:puts)
    allow(shell_double).to receive(:yes?).and_return(true)
  end

  context "already cloned" do
    before { allow(File).to receive(:directory?).with(path).and_return(true) }

    context "with local changes" do
      before { expect(subject).to receive(:system).with("git -C #{path} diff-index --quiet HEAD --").and_return(false) }

      it "doesn't pull the repo" do
        expect(subject).to_not receive(:system).with("git -C #{path} pull")
        subject.call
      end
    end

    context "without local changes" do
      before { expect(subject).to receive(:system).with("git -C #{path} diff-index --quiet HEAD --").and_return(true) }

      it "pulls the repo" do
        expect(subject).to receive(:system).with("git -C #{path} pull")
        subject.call
      end
    end
  end

  context "not already cloned" do
    before { allow(File).to receive(:directory?).with(path).and_return(false) }

    it "clones the repo" do
      expect(subject).to receive(:system).with("git clone https://github.com/alphagov/govuk-docker.git #{path}")
      subject.call
    end
  end
end
