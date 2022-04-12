# frozen_string_literal: true

require_relative "provider_configuration"

require_relative "circle_ci/base"
require_relative "circle_ci/api_request"
require_relative "circle_ci/artifact"
require_relative "circle_ci/job"
require_relative "circle_ci/pipeline"
require_relative "circle_ci/vcs"
require_relative "circle_ci/workflow"

module Jiminy
  module Reporting
    module CIProviders
      module CircleCI
        # Not currently used, but kept for future use.
        class Configuration < ProviderConfiguration
          PR_URL_MATCHERS = %r{github\.com/
            (?<username>[\w\-_]+)/
            (?<reponame>[\w\-_]+)/
            pull/
            (?<pr_number>\d+)}x.freeze

          def repo_path
            [project_username, project_reponame].join("/")
          end

          def pr_number
            match_data[:pr_number]
          end

          def project_username
            match_data[:username]
          end

          def project_reponame
            match_data[:reponame]
          end

          def github_token
            ensure_env_variable("GITHUB_TOKEN")
          end

          private

            def match_data
              @_match_data ||= ensure_env_variable("CIRCLE_PULL_REQUEST").match(PR_URL_MATCHERS)
            end
        end
      end
    end
  end
end
