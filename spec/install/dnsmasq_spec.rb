require "spec_helper"
require_relative "../../lib/install/dnsmasq"

describe Install::Dnsmasq do
  subject { described_class.new }

  let(:shell_double) { double }
  before do
    allow(Thor::Shell::Basic).to receive(:new).and_return(shell_double)
    allow(subject).to receive(:puts)
  end

  context "disallowing the script to continue" do
    it "shouldn't do anything" do
      expect(subject).to receive(:puts).with(/Any local changes/)
      expect(shell_double).to receive(:yes?).and_return(false)
      expect(Doctor::Dnsmasq).to_not receive(:new)
      expect(File).to_not receive(:read)
      expect(subject).to_not receive(:system)
      subject.call
    end
  end

  context "allowing the script to continue" do
    before do
      allow(shell_double).to receive(:yes?).and_return(true)
      allow(Doctor::Dnsmasq).to receive(:new).and_return(double(installed?: false))
      allow(subject).to receive(:system).with("brew install dnsmasq")
      allow(subject).to receive(:puts)
      allow(File).to receive(:read).with("/etc/resolver/dev.gov.uk").and_return("")
      allow(File).to receive(:read).with("/usr/local/etc/dnsmasq.conf").and_return("")
      allow(File).to receive(:read).with("/usr/local/etc/dnsmasq.d/development.conf").and_return("")
      allow(File).to receive(:write).with("/etc/resolver/dev.gov.uk", anything)
      allow(File).to receive(:open).with("/usr/local/etc/dnsmasq.conf", anything)
      allow(File).to receive(:write).with("/usr/local/etc/dnsmasq.d/development.conf", anything)
      allow(subject).to receive(:system).with("sudo brew services restart dnsmasq")
    end

    it "installs dnsmasq using brew" do
      expect(subject).to receive(:puts).with(/Installing/)
      expect(subject).to receive(:system).with("brew install dnsmasq")
      subject.call
    end

    it "writes to the various files" do
      expect(subject).to receive(:puts).with(/Writing/)
      expect(File).to receive(:write)
        .with("/etc/resolver/dev.gov.uk", "nameserver 127.0.0.1\n")
      expect(File).to receive(:write)
        .with("/usr/local/etc/dnsmasq.d/development.conf", "address=/dev.gov.uk/127.0.0.1\n")
      file_double = double
      expect(File).to receive(:open).with("/usr/local/etc/dnsmasq.conf", "a").and_yield(file_double)
      expect(file_double).to receive(:write).with("\nconf-dir=/usr/local/etc/dnsmasq.d,*.conf\n")

      subject.call
    end

    it "restarts dnsmasq" do
      expect(subject).to receive(:puts).with(/Restarting/)
      expect(subject).to receive(:system).with("sudo brew services restart dnsmasq")
      subject.call
    end

    context "dnsmasq is already installed" do
      before do
        expect(Doctor::Dnsmasq).to receive(:new).and_return(double(installed?: true))
      end

      it "doesn't install dnsmasq with brew" do
        expect(subject).to_not receive(:system).with("brew install dnsmasq")
        subject.call
      end
    end
  end
end
