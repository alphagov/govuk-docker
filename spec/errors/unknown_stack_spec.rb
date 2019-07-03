require "spec_helper"
require_relative "../../lib/errors/unknown_stack"

describe UnknownStack do
  it "should print a list of available stack in the error message" do
    incorrect_stack = 'incorrect'
    available_stacks = %w[test lite]

    expected_message = <<~MESSAGE
      Unknown stack: #{incorrect_stack}.\n
      Available stacks:\n
      test
      lite
    MESSAGE

    expect(described_class.new(incorrect_stack, available_stacks).message).to eq expected_message
  end
end
