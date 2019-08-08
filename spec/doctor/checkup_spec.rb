require "spec_helper"
require "./lib/govuk_docker/doctor/checkup"

describe GovukDocker::Doctor::Checkup do
  let(:service_name) { "fake_service" }
  let(:messages) {
    {
      up_to_date: "fake_service is up-to-date",
      outdated: "fake_service is outdated",
      installed: "fake_service is installed",
      not_installed: "fake_service is not installed",
      running: "fake_service is running",
      not_running: "fake_service is not running",
      running_as_different_user: "fake_service is running as correct user",
      not_running_as_different_user: "fake_service is not running as correct user",
      dnsmasq_resolver: "fake_service is resolving your dns",
      not_dnsmasq_resolver: "A different service is resolving your dns"
    }
  }

  context "when the repository is up-to-date" do
    it "should report that it is up-to-date" do
      subject = described_class.new(
        service_name: service_name,
        checkups: %i(up_to_date),
        messages: messages
      )

      ClimateControl.modify GOVUK_DOCKER_DIR: "/some/directory" do
        allow(subject)
          .to receive(:system)
          .with("git -C /some/directory diff master origin/master --exit-code --quiet")
          .and_return(true)

        expect(subject.call).to eq("fake_service is up-to-date")
      end
    end
  end

  context "when the repository is outdated" do
    it "should report that it is outdated" do
      subject = described_class.new(
        service_name: service_name,
        checkups: %i(up_to_date),
        messages: messages
      )

      ClimateControl.modify GOVUK_DOCKER_DIR: "/some/directory" do
        allow(subject)
          .to receive(:system)
          .with("git -C /some/directory diff master origin/master --exit-code --quiet")
          .and_return(false)

        expect(subject.call).to eq("fake_service is outdated")
      end
    end
  end

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

  context "when a service is installed to /usr/local/sbin" do
    subject do
      described_class.new(
        service_name: service_name,
        checkups: %i(installed),
        messages: messages
      )
    end

    before do
      expect(subject).to receive(:system).with("which fake_service 1>/dev/null").and_return(false)
      expect(File).to receive(:exist?).with("/usr/local/sbin/fake_service").and_return(true)
    end

    it "should report that it is installed" do
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

  context "when checking the running processes user" do
    it "should report when running as a different user" do
      subject = described_class.new(
        service_name: service_name,
        checkups: %i(running_as_different_user),
        messages: messages
      )

      allow(subject).to receive(:system).with("ps aux | grep `pgrep fake_service` | grep -v `whoami` 1>/dev/null").and_return(true)

      expect(subject.call).to eq("fake_service is running as correct user")
    end

    it "should report when running as the incorrect user" do
      subject = described_class.new(
        service_name: service_name,
        checkups: %i(running_as_different_user),
        messages: messages
      )

      allow(subject).to receive(:system).with("ps aux | grep `pgrep fake_service` | grep -v `whoami` 1>/dev/null").and_return(false)

      expect(subject.call).to eq("fake_service is not running as correct user")
    end
  end

  context "when checking dnsmasq resolver file" do
    let(:success_message) { "fake_service is resolving your dns" }
    let(:error_message) { "A different service is resolving your dns" }

    subject {
      described_class.new(
        service_name: service_name,
        checkups: %i(dnsmasq_resolver),
        messages: messages
      )
    }

    it "should report success when dnsmasq is resolving dns requests" do
      allow(File).to receive(:read).with("/etc/resolver/dev.gov.uk").and_return("nameserver 127.0.0.1")
      expect(subject.call).to eq(success_message)
    end

    it "should allow comments and empty lines in the dnsmasq resolver file" do
      allow(File).to receive(:read).with("/etc/resolver/dev.gov.uk").and_return("
        # this is a comment
        nameserver 127.0.0.1
      ")
      expect(subject.call).to eq(success_message)
    end

    it "should report when dnsmasq is not set to resolve dns requests" do
      allow(File).to receive(:read).with("/etc/resolver/dev.gov.uk").and_return("# this file is generated by vagrant-dns\nnameserver 127.0.0.1\nport 5300")
      expect(subject.call).to eq(error_message)
    end
  end
end
