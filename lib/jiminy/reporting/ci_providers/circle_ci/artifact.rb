module Jiminy
  module Reporting
    module CIProviders
      module CircleCI
        class Artifact < Base

          define_attribute_readers :url

          def self.all(job_number:)
            fetch_api_resource("project/gh/cookpad/N-1-Reporter/#{job_number}/artifacts")
          end
        end
      end
    end
  end
end