module Jiminy
  class CLI
    module ExitCodes
      class WorkflowNotSuccess < Base
        def initialize(status:)
          super("Workflow #{status}—aborting...", 0)
        end
      end
    end
  end
end
