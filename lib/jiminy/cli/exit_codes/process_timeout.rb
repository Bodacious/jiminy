module Jiminy
  class CLI
    module ExitCodes
      class ProcessTimeout < Base
        def initialize(start_time:)
          super("Process timed out after #{Time.now - start_time} seconds", 1)
        end
      end
    end
  end
end
