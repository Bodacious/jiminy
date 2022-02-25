module Jiminy
  module Reporting
    module CIProviders
      module CircleCI
        require_relative "base"
        require_relative "vcs"

        class Pipeline < Base
          MAX_PAGE_LOOKUP = 10

          define_attribute_readers :id, :project_slug, :vcs

          def self.find_by_revision(git_revision)
            attempt_count = 0
            matching_pipeline = nil
            until matching_pipeline || attempt_count >= MAX_PAGE_LOOKUP
              matching_pipeline = fetch_page_from_api(next_token).detect do |pipeline|
                pipeline.project_slug.to_s.downcase.end_with?(Jiminy.config.repo_path.downcase) &&
                  pipeline.vcs.revision == git_revision
              end
              attempt_count += 1
            end
            return matching_pipeline if matching_pipeline

            abort("Couldn't find matching pipeline")
          end

          def self.fetch_page_from_api(page_token)
            query = "org-slug=gh/#{Jiminy.config.project_username}&mine=false"
            query += "&page-token=#{page_token}" if page_token
            url = "pipeline?#{query}"
            fetch_api_resource(url)
          end

          def vcs
            VCS.new(attributes["vcs"])
          end
        end
      end
    end
  end
end
