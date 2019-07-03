require "spec_helper"
require_relative "../lib/govuk_docker_cli"

describe GovukDockerCLI do
  let(:command) { nil }
  let(:args) { [] }
  subject { described_class.start([command] + args) }
  let(:command_double) { instance_double Commands::Run }
  before { allow(command_double).to receive(:call) }

  describe "run" do
    let(:command) { "run" }

    context "without a stack argument" do
      it "runs in the lite stack" do
        expect(Commands::Run)
          .to receive(:new).with("lite", [])
          .and_return(command_double)
        subject
      end
    end

    context "with a stack argument" do
      let(:args) { ["--stack", "app"] }

      it "runs in the specified stack" do
        expect(Commands::Run)
          .to receive(:new).with("app", [])
          .and_return(command_double)
        subject
      end
    end

    context "with additional arguments" do
      let(:args) { %w[bundle exec rspec] }

      it "runs the command with additinal arguments" do
        expect(Commands::Run)
          .to receive(:new).with("lite", %w[bundle exec rspec])
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
          .to receive(:new).with("app", [])
          .and_return(command_double)
        subject
      end
    end

    context "with a variation argument" do
      let(:args) { %w(live) }

      it "runs in the specified stack" do
        expect(Commands::Run)
          .to receive(:new).with("app-live", [])
          .and_return(command_double)
        subject
      end
    end
  end
end
