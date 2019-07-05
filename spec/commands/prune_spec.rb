require "spec_helper"
require_relative "../../lib/govuk_docker/commands/prune"

describe Commands::Prune do
  let(:config_directory) { "spec/fixtures" }
  subject { described_class.new(config_directory: config_directory) }

  before do
    allow(subject).to receive(:system) { 0 }
  end

  it "removes exited containers" do
    expect(subject).to receive(:system).with("docker container prune -f")
    subject.call
  end

  it "removes temporary anonymous volumes" do
    expect(subject).to receive(:system).with("docker volume rm $(docker volume ls -q -f 'dangling=true' | grep -x '.{64,}') 2> /dev/null")
    subject.call
  end

  it "removes temporary anonymous images" do
    expect(subject).to receive(:system).with("docker image prune -f")
    subject.call
  end

  it "can be initialized with no arguments" do
    described_class.new
  end
end
