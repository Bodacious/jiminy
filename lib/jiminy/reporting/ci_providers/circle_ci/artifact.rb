# frozen_string_literal: true

module Jiminy
  module Reporting
    module CIProviders
      module CircleCI
        class Artifact < Base
          define_attribute_readers :url

          def self.all(job_number:)
            # TODO: Support different results names here
            fetch_api_resource("project/gh/#{Jiminy.config.repo_path}/#{job_number}/artifacts").
              select { |artifact| artifact.url.end_with?("jiminy/results.yml") }
          end
        end
      end
    end
  end
end
