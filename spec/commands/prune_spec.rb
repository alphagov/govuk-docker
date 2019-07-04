require "spec_helper"
require_relative "../../lib/commands/prune"

describe Commands::Prune do
  let(:config_directory) { "spec/fixtures" }

  subject { described_class.new(nil, config_directory) }

  it "calls the necessary prune commands" do
    expect(subject).to receive(:system).with("docker container prune -f")
    expect(subject).to receive(:system).with("docker volume rm $(docker volume ls -q -f 'dangling=true' | grep -x '.{64,}') 2> /dev/null")
    expect(subject).to receive(:system).with("docker image prune -f")

    subject.call
  end
end
