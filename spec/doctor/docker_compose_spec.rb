require "spec_helper"
require "./lib/doctor/docker_compose.rb"

describe Doctor::DockerCompose do
  subject { described_class.new }

  context "when docker compose is installed" do
    it "should tell me that docker compose is installed" do
      allow(subject).to receive(:system).with("which docker-compose 1>/dev/null").and_return(true)
      expect(subject.call).to include("Docker Compose is installed")
    end
  end

  context "when docker is not installed" do
    it "should tell me to install docker" do
      allow(subject).to receive(:system).with("which docker-compose 1>/dev/null").and_return(false)
      expect(subject.call).to include("Docker Compose not found")
    end
  end
end
