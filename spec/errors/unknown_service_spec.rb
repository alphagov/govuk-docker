require "spec_helper"
require_relative "../../lib/govuk_docker/errors/unknown_service"

describe GovukDocker::UnknownService do
  it "should print a list of available services in the error message" do
    incorrect_service = 'incorrect_service'
    config_directory = 'spec/fixtures'

    available_service = "example-service\nnginx-proxy"

    expected_message = <<~MESSAGE
      Unknown service: #{incorrect_service}.\n
      Available services:\n
      #{available_service}
    MESSAGE

    expect(described_class.new(incorrect_service, config_directory).message).to eq expected_message
  end
end
