require "spec_helper"
require_relative "../../lib/govuk_docker/setup/dnsmasq"

describe GovukDocker::Setup::Dnsmasq do
  let(:shell_double) { double }

  subject { described_class.new(shell_double) }
  before { allow(subject).to receive(:puts) }

  context "disallowing the script to continue" do
    it "shouldn't do anything" do
      expect(subject).to receive(:puts).with(/Any local changes/)
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
      allow(GovukDocker::Doctor::Checkup).to receive(:new).with(service_name: "dnsmasq", checkups: %i(installed), messages: {}).and_return(double(installed?: false))
      allow(subject).to receive(:system).with("brew install dnsmasq")
      allow(subject).to receive(:puts)
      allow(subject).to receive(:system).with("echo \"nameserver 127.0.0.1\n\" | sudo tee /etc/resolver/dev.gov.uk")
      allow(subject).to receive(:system).with("sudo mkdir /etc/resolver")
      allow(subject).to receive(:ensure_directory_exists).with("/usr/local/etc/", false).and_return(true)
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
      expect(subject).to receive(:system).with("echo \"nameserver 127.0.0.1\n\" | sudo tee /etc/resolver/dev.gov.uk")
      expect(File).to receive(:write)
        .with("/usr/local/etc/dnsmasq.d/development.conf", "address=/dev.gov.uk/127.0.0.1\n")
      file_double = double
      expect(File).to receive(:open).with("/usr/local/etc/dnsmasq.conf", "a").and_yield(file_double)
      expect(file_double).to receive(:write).with("\nconf-dir=/usr/local/etc/dnsmasq.d,*.conf\n")

      subject.call
    end

    it "creates /etc/resolver directory as sudo if it does not yet exist" do
      expect(File).to receive(:dirname)
        .with("/etc/resolver/dev.gov.uk")
        .and_return("/etc/resolver")
      expect(Dir).to receive(:exist?)
        .with("/etc/resolver")
        .and_return(false)

      allow(File).to receive(:dirname)
        .with("/usr/local/etc/dnsmasq.d/development.conf")
        .and_return("/usr/local/etc/dnsmasq.d")
      allow(Dir).to receive(:exist?)
        .with("/usr/local/etc/dnsmasq.d")
        .and_return(true)

      expect(subject).to receive(:puts).with(/Creating directory/)
      expect(subject).to receive(:system).with("sudo mkdir /etc/resolver")
      expect(subject).to receive(:system).with("echo \"nameserver 127.0.0.1\n\" | sudo tee /etc/resolver/dev.gov.uk")

      subject.call
    end

    it "creates /usr/local/etc/dnsmasq.d if the directory does not exist" do
      expect(File).to receive(:dirname)
        .with("/usr/local/etc/dnsmasq.d/development.conf")
        .and_return("/usr/local/etc/dnsmasq.d")
      expect(Dir).to receive(:exist?)
        .with("/usr/local/etc/dnsmasq.d")
        .and_return(false)

      allow(File).to receive(:dirname)
        .with("/etc/resolver/dev.gov.uk")
        .and_return("/etc/resolver")
      allow(Dir).to receive(:exist?)
        .with("/etc/resolver")
        .and_return(true)

      expect(subject).to receive(:puts).with(/Creating directory/)
      allow(subject).to receive(:system).with("echo \"nameserver 127.0.0.1\n\" | sudo tee /etc/resolver/dev.gov.uk")
      expect(Dir).to receive(:mkdir).with("/usr/local/etc/dnsmasq.d")

      subject.call
    end

    it "restarts dnsmasq" do
      expect(subject).to receive(:puts).with(/Restarting/)
      expect(subject).to receive(:system).with("sudo brew services restart dnsmasq")
      expect(subject).to receive(:system).with("echo \"nameserver 127.0.0.1\n\" | sudo tee /etc/resolver/dev.gov.uk")
      subject.call
    end

    context "dnsmasq is already installed" do
      before do
        expect(GovukDocker::Doctor::Checkup).to receive(:new).with(service_name: "dnsmasq", checkups: %i(installed), messages: {}).and_return(double(installed?: true))
      end

      it "doesn't install dnsmasq with brew" do
        expect(subject).to_not receive(:system).with("brew install dnsmasq")
        subject.call
      end
    end
  end
end
