module Jiminy
  module Reporting
    module CIProviders
      module CircleCI
        class Workflow < Base
          # Link to states: https://circleci.com/docs/2.0/workflows/#states
          SUCCESS = "success".freeze
          FAILED = "failed".freeze
          NOT_RUN = "not run".freeze
          RUNNING = "running".freeze

          define_attribute_readers :id, :name, :status

          def self.find(pipeline_id:, workflow_name:)
            url = "pipeline/#{pipeline_id}/workflow"
            collection = fetch_api_resource(url)
            collection.detect { |w| w.name.to_s == workflow_name.to_s }
          end
        end
      end
    end
  end
end
