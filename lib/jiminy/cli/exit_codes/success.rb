module Jiminy
  class CLI
    module ExitCodes
      class Success < Base
        def initialize
          super("Reported N+1s successfully", 0)
        end
      end
    end
  end
end
