# frozen_string_literal: true

module Jiminy
  module Reporting
    module CIProviders
      module CircleCI
        class Workflow < Base
          # Link to states: https://circleci.com/docs/2.0/workflows/#states
          SUCCESS = "success"
          FAILED = "failed"
          NOT_RUN = "not run"
          RUNNING = "running"

          define_attribute_readers :id, :name, :status

          def self.find(pipeline_id:, workflow_name:)
            url = "pipeline/#{pipeline_id}/workflow"
            collection = fetch_api_resource(url)
            collection.detect { |w| w.name.to_s == workflow_name.to_s }
          end

          def success?
            status == SUCCESS
          end

          def running?
            status == RUNNING
          end

          def not_run?
            status == NOT_RUN
          end

          def failed?
            status == FAILED
          end
        end
      end
    end
  end
end
