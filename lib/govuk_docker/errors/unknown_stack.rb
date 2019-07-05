class GovukDocker::UnknownStack < Thor::Error
  def initialize(stack, available_stacks)
    @stack = stack
    @available_stacks = available_stacks
    super(message)
  end

  def message
    <<~ERROR_MESSAGE
      Unknown stack: #{stack}.\n
      Available stacks:\n
      #{available_stacks.join("\n")}
    ERROR_MESSAGE
  end

private

  attr_reader :stack, :available_stacks
end
