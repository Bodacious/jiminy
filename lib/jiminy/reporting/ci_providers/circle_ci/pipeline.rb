# frozen_string_literal: true

module Jiminy
  module Reporting
    module CIProviders
      module CircleCI
        require_relative "base"
        require_relative "vcs"

        class Pipeline < Base
          MAX_PAGE_LOOKUP = 20

          define_attribute_readers :id, :project_slug, :vcs

          def self.find_by_revision(git_revision:, pr_number:)
            attempt_count = 0
            matching_pipeline = nil
            until matching_pipeline || attempt_count >= MAX_PAGE_LOOKUP
              page_pipelines = fetch_page_from_api(next_token)
              matching_pipeline = page_pipelines.detect { |p| pipeline_match?(p, git_revision, pr_number) }
              attempt_count += 1
            end
            matching_pipeline
          end

          def self.fetch_page_from_api(page_token)
            query = "org-slug=gh/#{Jiminy.config.project_username}&mine=false"
            query += "&page-token=#{page_token}" if page_token
            url = "pipeline?#{query}"
            fetch_api_resource(url)
          end

          def self.pipeline_match?(pipeline, git_revision, _pr_number)
            return false unless pipeline.project_slug.to_s.downcase.end_with?(Jiminy.config.repo_path.downcase)

            pipeline.vcs.revision == git_revision

            # TODO: Get PR comparison working too
            # pipeline.vcs.review_url.end_with?("pull/#{pr_number}")
          end

          def vcs
            VCS.new(attributes["vcs"])
          end
        end
      end
    end
  end
end
