# frozen_string_literal: true
require_relative "provider_configuration"

module Jiminy
  module Reporting
    module CIProviders
      module Github
        class Configuration < ProviderConfiguration
          def repo_path
            ensure_configuration(:github_repository)
          end

          def pr_number
            ensure_configuration(:pr_number)
          end

          def project_username
            repo_path.to_s.split("/").first
          end

          def project_reponame
            repo_path.to_s.split("/").last
          end

          def github_access_token
            ensure_env_variable("GITHUB_TOKEN")
          end
        end
      end
    end
  end
end