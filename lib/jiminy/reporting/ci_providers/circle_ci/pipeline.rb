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
            puts "GITHUB_SHA: #{Jiminy.config.git_commit}"
            puts "GITHUB_REPOSITORY: #{Jiminy.config.github_repository}"
            puts "CircleCI token present" if Jiminy.config.circle_ci_api_token.present?
            puts "RUBY version #{RUBY_VERSION}"
            attempt_count = 0
            matching_pipeline = nil
            until matching_pipeline || attempt_count >= MAX_PAGE_LOOKUP
              matching_pipeline = fetch_page_from_api(next_token).detect do |pipeline|
                pipeline.project_slug.to_s.downcase.end_with?(ENV["GITHUB_REPOSITORY"].downcase) &&
                  pipeline.vcs.revision == git_revision
              end
              attempt_count += 1
            end
            return matching_pipeline if matching_pipeline

            puts "Couldn't find matching pipeline"
            exit(1)
          end

          def self.fetch_page_from_api(page_token)
            query = "org-slug=gh/#{ENV['GITHUB_REPOSITORY_OWNER']}&mine=false"
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