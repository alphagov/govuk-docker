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
    let(:stack) { "lite" }

    let(:compose_command) { instance_double Commands::Compose }
    before { expect(Commands::Compose).to receive(:new).and_return(compose_command) }

    context "with no extra arguments" do
      let(:args) { [] }

      it "should run docker compose" do
        expect(compose_command).to receive(:call).with(
          "run", "--rm", "--service-ports", "example-service-lite"
        )
        subject.call
      end
    end

    context "with some extra arguments" do
      let(:args) { %w[bundle exec rake lint] }

      it "should run docker compose using the `env` command" do
        expect(compose_command).to receive(:call).with(
          "run", "--rm", "--service-ports", "example-service-lite",
          "env", "bundle", "exec", "rake", "lint"
        )
        subject.call
      end
    end

    context "with an env command" do
      let(:args) { %w[env bundle exec rake lint] }

      it "should run docker compose without duplicating `env`" do
        expect(compose_command).to receive(:call).with(
          "run", "--rm", "--service-ports", "example-service-lite",
          "env", "bundle", "exec", "rake", "lint"
        )
        subject.call
      end
    end
  end

  context "with a service that doesn't exist" do
    let(:service) { "no-example-service" }
    let(:stack) { "lite" }

    it "should fail" do
      expect { subject.call }.to raise_error(UnknownService)
    end
  end

  context "with a stack that doesn't exist" do
    let(:service) { "example-service" }
    let(:stack) { "no-example-stack" }

    it "should fail" do
      expect { subject.call }.to raise_error(UnknownStack)
    end
  end
end
