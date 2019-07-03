require "spec_helper"
require_relative "../../lib/commands/run"

describe Commands::Run do
  let(:config_directory) { "spec/fixtures" }
  let(:service) { nil }
  let(:stack) { nil }
  let(:args) { nil }

  subject { described_class.new(stack, args, service, config_directory) }

  context "with a service that exists" do
    let(:service) { "example-service" }
    let(:stack) { "default" }

    let(:compose_command) { double }
    before { expect(Commands::Compose).to receive(:new).and_return(compose_command) }

    context "with no extra arguments" do
      let(:args) { [] }

      it "should run docker compose" do
        expect(compose_command).to receive(:call).with(
          "run", "--rm", "--service-ports", "example-service-default"
        )
        subject.call
      end
    end

    context "with some extra arguments" do
      let(:args) { ["bundle", "exec", "rake", "lint"] }

      it "should run docker compose using the `env` command" do
        expect(compose_command).to receive(:call).with(
          "run", "--rm", "--service-ports", "example-service-default",
          "env", "bundle", "exec", "rake", "lint"
        )
        subject.call
      end
    end

    context "with an env command" do
      let(:args) { ["env", "bundle", "exec", "rake", "lint"] }

      it "should run docker compose without duplicating `env`" do
        expect(compose_command).to receive(:call).with(
          "run", "--rm", "--service-ports", "example-service-default",
          "env", "bundle", "exec", "rake", "lint"
        )
        subject.call
      end
    end
  end

  context "with a service that doesn't exist" do
    let(:service) { "no-example-service" }

    it "should fail" do
      expect { subject.call }.to raise_error(UnknownService)
    end
  end
end
