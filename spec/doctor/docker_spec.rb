require "spec_helper"
require "./lib/doctor/docker.rb"

describe Doctor::Docker do
  subject { described_class.new }

  context "when docker is installed" do
    it "should tell me that docker is installed" do
      allow(subject).to receive(:system).with("which docker 1>/dev/null").and_return(true)
      expect(subject.call).to include("Docker is installed")
    end
  end

  context "when docker is not installed" do
    it "should tell me to install docker" do
      allow(subject).to receive(:system).with("which docker 1>/dev/null").and_return(false)
      expect(subject.call).to include("Docker not found")
    end
  end
end
