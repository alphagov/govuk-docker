require_relative './base'
require_relative './compose'
require_relative '../container'
require_relative '../stack'

class GovukDocker::Commands::Run < GovukDocker::Commands::Base
  def call(args = [])
    stack.dependencies.each do |d|
      GovukDocker::Container.new(d).start
    end

    GovukDocker::Container.new(stack)
      .run(extra_args: args)
  end

private

  def stack
    name = "#{service_name}-#{stack_name}"
    GovukDocker::Stack.find(name)
  end

  attr_reader :args
end
