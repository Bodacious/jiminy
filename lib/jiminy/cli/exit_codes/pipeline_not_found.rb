module Jiminy
  class CLI
    module ExitCodes
      class PipelineNotFound < Base
        def initialize(git_revision:)
          super("No such Pipeline with commit SHA #{git_revision}", 1)
        end
      end
    end
  end
end
