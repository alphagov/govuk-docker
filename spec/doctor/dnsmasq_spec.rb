require "spec_helper"
require "./lib/doctor/dnsmasq"

describe Doctor::Dnsmasq do
  subject { described_class.new }

  context "when dnsmasq is not installed" do
    it "should tell me to install dnsmasq if it is not yet installed" do
      allow(subject).to receive(:system).with("which dnsmasq 1>/dev/null").and_return(false)
      expect(subject.call).to include("Dnsmasq not found")
    end
  end

  context "when dnsmasq is installed" do
    it "should report that dnsmasq is installed if it is" do
      allow(subject).to receive(:system).with("which dnsmasq 1>/dev/null").and_return(true)
      allow(subject).to receive(:system).with("pgrep dnsmasq 1>/dev/null")
      expect(subject.call).to include("Dnsmasq is installed")
    end

    it "should report that dnsmasq is running" do
      allow(subject).to receive(:system).with("which dnsmasq 1>/dev/null").and_return(true)
      allow(subject).to receive(:system).with("pgrep dnsmasq 1>/dev/null").and_return(true)
      expect(subject.call).to include("Dnsmasq is running")
    end

    it "should tell me to start dnsmasq if it is not running" do
      allow(subject).to receive(:system).with("which dnsmasq 1>/dev/null").and_return(true)
      allow(subject).to receive(:system).with("pgrep dnsmasq 1>/dev/null").and_return(false)
      expect(subject.call).to include("sudo brew services start dnsmasq")
    end
  end
end
