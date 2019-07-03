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
          .to receive(:new).with("lite", false, [], nil)
          .and_return(command_double)
        subject
      end
    end

    context "with stack and service arguments" do
      let(:args) { ["--service", "static", "--stack", "app"] }

      it "runs in the specified stack" do
        expect(Commands::Run)
          .to receive(:new).with("app", false, [], "static")
          .and_return(command_double)
        subject
      end
    end

    context "with stack argument and no service argument" do
      let(:args) { ["--stack", "app"] }

      it "runs in the specified stack" do
        expect(Commands::Run)
          .to receive(:new).with("app", false, [], nil)
          .and_return(command_double)
        subject
      end
    end

    context "with service argument and no stack argument" do
      let(:args) { ["--service", "static"] }

      it "runs in the specified stack" do
        expect(Commands::Run)
          .to receive(:new).with("lite", false, [], "static")
          .and_return(command_double)
        subject
      end
    end

    context "with additional arguments" do
      let(:args) { %w[bundle exec rspec] }

      it "runs the command with additional arguments" do
        expect(Commands::Run)
          .to receive(:new).with("lite", false, ["bundle", "exec", "rspec"], nil)
          .and_return(command_double)
        subject
      end
    end

    context "with a verbose argument" do
      let(:args) { ["--verbose"] }
        it "runs in the verbose mode" do
        expect(Commands::Run)
          .to receive(:new).with('lite', true, [], nil)
          .and_return(command_double)
        subject
      end
    end

    context "without a verbose argument" do
      let(:args) { [] }
        it "runs in silent mode" do
        expect(Commands::Run)
          .to receive(:new).with('lite', false, [], nil)
          .and_return(command_double)
        subject
      end
    end
  end

  describe "startup" do
    let(:command) { "startup" }

    context "without a variation argument" do
      it "runs in the backend stack" do
        expect(Commands::Run)
          .to receive(:new).with("app", false, [])
          .and_return(command_double)
        subject
      end
    end

    context "with a variation argument" do
      let(:args) { %w(live) }

      it "runs in the specified stack" do
        expect(Commands::Run)
          .to receive(:new).with("app-live", false, [])
          .and_return(command_double)
        subject
      end
    end
  end

  describe "build" do
    let(:command) { "build" }

    context "without the service argument" do
      it "builds the working directory's service" do
        expect(Commands::Build)
          .to receive(:new).with(nil)
          .and_return(command_double)
        subject
      end
    end

    context "with the service argument" do
      let(:args) { ["--service", "static"] }

      it "builds the specified service" do
        expect(Commands::Build)
          .to receive(:new).with("static")
          .and_return(command_double)
        subject
      end
    end
  end
end
