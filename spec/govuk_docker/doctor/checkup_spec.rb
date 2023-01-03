require "spec_helper"

RSpec.describe GovukDocker::Doctor::Checkup do
  let(:service_name) { "fake_service" }
  let(:messages) do
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
      not_dnsmasq_resolver: "A different service is resolving your dns",
    }
  end

  context "when the repository is up-to-date" do
    it "should report that it is up-to-date" do
      subject = described_class.new(
        service_name:,
        checkups: %i[up_to_date],
        messages:,
      )

      ClimateControl.modify GOVUK_DOCKER_DIR: "/some/directory" do
        allow(subject)
          .to receive(:system)
          .with("git -C /some/directory diff main origin/main --exit-code --quiet")
          .and_return(true)

        expect(subject.call).to eq("fake_service is up-to-date")
      end
    end
  end

  context "when the repository is outdated" do
    it "should report that it is outdated" do
      subject = described_class.new(
        service_name:,
        checkups: %i[up_to_date],
        messages:,
      )

      ClimateControl.modify GOVUK_DOCKER_DIR: "/some/directory" do
        allow(subject)
          .to receive(:system)
          .with("git -C /some/directory diff main origin/main --exit-code --quiet")
          .and_return(false)

        expect(subject.call).to eq("fake_service is outdated")
      end
    end
  end

  context "when a service is installed" do
    it "should report that it is installed" do
      subject = described_class.new(
        service_name:,
        checkups: %i[installed],
        messages:,
      )

      allow(subject).to receive(:system).with("which fake_service 1>/dev/null").and_return(true)

      expect(subject.call).to eq("fake_service is installed")
    end
  end

  context "when a service is installed to /usr/local/sbin" do
    subject do
      described_class.new(
        service_name:,
        checkups: %i[installed],
        messages:,
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
        service_name:,
        checkups: %i[installed],
        messages:,
      )

      allow(subject).to receive(:system).with("which fake_service 1>/dev/null").and_return(false)

      expect(subject.call).to eq("fake_service is not installed")
    end
  end

  context "when a service is running" do
    it "should report that it is running" do
      subject = described_class.new(
        service_name:,
        checkups: %i[running],
        messages:,
      )

      allow(subject).to receive(:system).with("pgrep fake_service 1>/dev/null").and_return(true)

      expect(subject.call).to eq("fake_service is running")
    end
  end

  context "when a service is not running" do
    it "should report that it needs to be running" do
      subject = described_class.new(
        service_name:,
        checkups: %i[running],
        messages:,
      )

      allow(subject).to receive(:system).with("pgrep fake_service 1>/dev/null").and_return(false)

      expect(subject.call).to eq("fake_service is not running")
    end
  end

  context "when a service is installed and running" do
    it "should report that it is installed and running" do
      subject = described_class.new(
        service_name:,
        checkups: %i[installed running],
        messages:,
      )

      allow(subject).to receive(:system).with("pgrep fake_service 1>/dev/null").and_return(true)
      allow(subject).to receive(:system).with("which fake_service 1>/dev/null").and_return(true)

      expect(subject.call).to eq("fake_service is installed\r\nfake_service is running")
    end
  end

  context "when checking the running processes user" do
    it "should report when running as a different user" do
      subject = described_class.new(
        service_name:,
        checkups: %i[running_as_different_user],
        messages:,
      )

      allow(subject).to receive(:system).with("pgrep fake_service 1>/dev/null").and_return(true)
      allow(subject).to receive(:system).with("pgrep -u `whoami` fake_service 1>/dev/null").and_return(false)

      expect(subject.call).to eq("fake_service is running as correct user")
    end

    it "should report when running as the incorrect user" do
      subject = described_class.new(
        service_name:,
        checkups: %i[running_as_different_user],
        messages:,
      )

      allow(subject).to receive(:system).with("pgrep fake_service 1>/dev/null").and_return(true)
      allow(subject).to receive(:system).with("pgrep -u `whoami` fake_service 1>/dev/null").and_return(true)

      expect(subject.call).to eq("fake_service is not running as correct user")
    end
  end

  context "when checking dnsmasq resolver file" do
    subject do
      described_class.new(
        service_name:,
        checkups: %i[dnsmasq_resolver],
        messages:,
      )
    end

    it "should report success if dnsmasq conf matches the one in govuk-docker" do
      dns_config = "nameserver 127.0.0.1\nport 53"
      allow(File).to receive(:read).and_call_original
      allow(File).to receive(:read).with("/etc/resolver/dev.gov.uk").and_return(dns_config)

      expect(subject.call).to eq("fake_service is resolving your dns")
    end

    it "should report failure when dnsmasq conf differs from the one in govuk-docker" do
      allow(File).to receive(:read).and_call_original
      allow(File).to receive(:read).with("/etc/resolver/dev.gov.uk").and_return("# this file is generated by vagrant-dns\nnameserver 127.0.0.1\nport 5300")

      expect(subject.call).to eq("A different service is resolving your dns")
    end
  end
end
