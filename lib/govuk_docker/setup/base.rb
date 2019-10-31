module GovukDocker::Setup
  class Base
    def initialize(shell)
      @shell = shell
    end

  private

    attr_reader :shell
  end
end
