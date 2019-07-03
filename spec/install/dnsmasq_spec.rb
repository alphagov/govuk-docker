require "spec_helper"
require_relative "../../lib/install/dnsmasq"

describe Install::Dnsmasq do
  subject { described_class.new }

  context "dnsmasq isn't installed" do
    before do
      allow(Doctor::Dnsmasq).to receive(:new).and_return(double(installed?: false))
    end

    it "installs dnsmasq using brew" do
      expect(subject).to receive(:system).with("brew install dnsmasq")
      subject.call
    end
  end

  context "dnsmasq is installed" do
    before do
      allow(Doctor::Dnsmasq).to receive(:new).and_return(double(installed?: true))
    end

    it "doesn't install dnsmasq with brew" do
      expect(subject).to_not receive(:system).with("brew install dnsmasq")
      subject.call
    end
  end
end
