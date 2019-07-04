require "spec_helper"
require "./lib/doctor/checkup"

describe Doctor::Checkup do
  let(:service_name) { "fake_service" }
  let(:messages) {
    {
      installed: "fake_service is installed",
      not_installed: "fake_service is not installed",
      running: "fake_service is running",
      not_running: "fake_service is not running"
    }
  }

  context "when a service is installed" do
    it "should report that it is installed" do
      subject = described_class.new(
        service_name: service_name,
        checkups: %i(installed),
        messages: messages
      )

      allow(subject).to receive(:system).with("which fake_service 1>/dev/null").and_return(true)

      expect(subject.call).to eq("fake_service is installed")
    end
  end

  context "when a service is not installed" do
    it "should report that it needs to be installed" do
      subject = described_class.new(
        service_name: service_name,
        checkups: %i(installed),
        messages: messages
      )

      allow(subject).to receive(:system).with("which fake_service 1>/dev/null").and_return(false)

      expect(subject.call).to eq("fake_service is not installed")
    end
  end

  context "when a service is running" do
    it "should report that it is running" do
      subject = described_class.new(
        service_name: service_name,
        checkups: %i(running),
        messages: messages
      )

      allow(subject).to receive(:system).with("pgrep fake_service 1>/dev/null").and_return(true)

      expect(subject.call).to eq("fake_service is running")
    end
  end

  context "when a service is not running" do
    it "should report that it needs to be running" do
      subject = described_class.new(
        service_name: service_name,
        checkups: %i(running),
        messages: messages
      )

      allow(subject).to receive(:system).with("pgrep fake_service 1>/dev/null").and_return(false)

      expect(subject.call).to eq("fake_service is not running")
    end
  end

  context "when a service is installed and running" do
    it "should report that it is installed and running" do
      subject = described_class.new(
        service_name: service_name,
        checkups: %i(installed running),
        messages: messages
      )

      allow(subject).to receive(:system).with("pgrep fake_service 1>/dev/null").and_return(true)
      allow(subject).to receive(:system).with("which fake_service 1>/dev/null").and_return(true)

      expect(subject.call).to eq("fake_service is installed\r\nfake_service is running")
    end
  end
end
