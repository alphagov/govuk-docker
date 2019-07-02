require "spec_helper"
require_relative "../../lib/commands/prune"

describe Commands::Prune do
  let(:config_directory) { "spec/fixtures" }
  let(:fake_system) { double }

  subject { described_class.new(nil, config_directory, fake_system) }

  it "calls the necessary prune commands" do
    expect(fake_system).to receive(:call).with("docker container prune -f")
    expect(fake_system).to receive(:call).with("docker volume rm $(docker volume ls -q -f 'dangling=true' | grep -x '.{64,}') 2> /dev/null")
    expect(fake_system).to receive(:call).with("docker image prune -f")

    subject.call
  end
end
