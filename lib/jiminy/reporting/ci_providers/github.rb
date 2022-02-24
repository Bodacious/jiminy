# frozen_string_literal: true

module NPlusOneReporting
  module CIProviders
    module Github
      class Configuration < ProviderConfiguration
        def repo_path
          ensure_env_variable("GITHUB_REPOSITORY")
        end

        def pr_number
          ensure_env_variable("GITHUB_REF").to_s.match(/refs\/pull\/(\d+)\//)[1]
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
