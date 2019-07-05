require "spec_helper"
require_relative "../lib/govuk_docker_cli"

describe GovukDockerCLI do
  let(:command) { nil }
  let(:args) { [] }
  subject { described_class.start([command] + args) }
  let(:command_double) { double }
  before { allow(command_double).to receive(:call) }

  describe "run" do
    let(:command) { "run" }

    context "without stack and service arguments" do
      it "runs in the lite stack" do
        expect(Commands::Run)
          .to receive(:new).with(stack: "lite", verbose: false)
          .and_return(command_double)
        expect(command_double).to receive(:call).with([])
        subject
      end
    end

    context "with stack and service arguments" do
      let(:args) { ["--service", "static", "--stack", "app"] }

      it "runs in the specified stack" do
        expect(Commands::Run)
          .to receive(:new).with(service: "static", stack: "app", verbose: false)
          .and_return(command_double)
        expect(command_double).to receive(:call).with([])
        subject
      end
    end

    context "with stack argument and no service argument" do
      let(:args) { ["--stack", "app"] }

      it "runs in the specified stack" do
        expect(Commands::Run)
          .to receive(:new).with(stack: "app", verbose: false)
          .and_return(command_double)
        expect(command_double).to receive(:call).with([])
        subject
      end
    end

    context "with service argument and no stack argument" do
      let(:args) { ["--service", "static"] }

      it "runs in the specified stack" do
        expect(Commands::Run)
          .to receive(:new).with(service: "static", stack: "lite", verbose: false)
          .and_return(command_double)
        expect(command_double).to receive(:call).with([])
        subject
      end
    end

    context "with additional arguments" do
      let(:args) { %w[bundle exec rspec] }

      it "runs the command with additional arguments" do
        expect(Commands::Run)
          .to receive(:new).with(stack: "lite", verbose: false)
          .and_return(command_double)
        expect(command_double).to receive(:call).with(%w[bundle exec rspec])
        subject
      end
    end

    context "with a verbose argument" do
      let(:args) { ["--verbose"] }
      it "runs in the verbose mode" do
        expect(Commands::Run)
          .to receive(:new).with(stack: "lite", verbose: true)
          .and_return(command_double)
        expect(command_double).to receive(:call).with([])
        subject
      end
    end

    context "without a verbose argument" do
      let(:args) { [] }
      it "runs in silent mode" do
        expect(Commands::Run)
          .to receive(:new).with(stack: "lite", verbose: false)
          .and_return(command_double)
        expect(command_double).to receive(:call).with([])
        subject
      end
    end
  end

  describe "startup" do
    let(:command) { "startup" }

    context "without a variation argument" do
      it "runs in the app stack" do
        expect(Commands::Startup).to receive(:new).and_return(command_double)
        expect(command_double).to receive(:call).with(nil)
        subject
      end
    end

    context "with a variation argument" do
      let(:args) { %w(live) }

      it "runs in the specified stack" do
        expect(Commands::Startup).to receive(:new).and_return(command_double)
        expect(command_double).to receive(:call).with("live")
        subject
      end
    end
  end

  describe "build" do
    let(:command) { "build" }

    context "without the service argument" do
      it "builds the working directory's service" do
        expect(Commands::Build)
          .to receive(:new).with(stack: "lite", verbose: false)
          .and_return(command_double)
        subject
      end
    end

    context "with the service argument" do
      let(:args) { ["--service", "static"] }

      it "builds the specified service" do
        expect(Commands::Build)
          .to receive(:new).with(service: "static", stack: "lite", verbose: false)
          .and_return(command_double)
        subject
      end
    end
  end
end
