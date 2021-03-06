# frozen_string_literal: true

module Jiminy
  module Reporting
    module CIProviders
      module CircleCI
        class Job < Base
          define_attribute_readers :job_number, :name

          def self.all(workflow_id:)
            fetch_api_resource("workflow/#{workflow_id}/job")
          end
        end
      end
    end
  end
end
