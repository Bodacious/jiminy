module Jiminy
  class CLI
    module ExitCodes
      class WorkflowNotFound < Base
        def initialize(pipeline_id:, workflow_name:)
          super("Unable to find workflow called '#{workflow_name}' in Pipeline #{pipeline_id}", 1)
        end
      end
    end
  end
end
