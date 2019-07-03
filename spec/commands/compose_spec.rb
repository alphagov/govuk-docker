require "spec_helper"
require_relative "../../lib/commands/compose"

describe Commands::Compose do
  let(:fake_system) { double }
  let(:config_directory) { "spec/fixtures" }
  let(:verbose) { true }

  subject { described_class.new(nil, config_directory, fake_system) }

  it "calls docker-compose with the correct configure files and arguments" do
    expect(fake_system).to receive(:call).with(
      "docker-compose",
      "-f", "spec/fixtures/docker-compose.yml",
      "-f", "spec/fixtures/services/example-service/docker-compose.yml",
      "fake args"
    )

    subject.call(verbose, "fake args")
  end
end
