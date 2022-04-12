# frozen_string_literal: true

require_relative "provider_configuration"
require_relative "local/artifact"

module Jiminy
  module Reporting
    module CIProviders
      module Local
        class Configuration < ProviderConfiguration
          def repo_path
            ensure_configuration(:repo_path)
          end

          def project_username
            repo_path.to_s.split("/").first
          end

          def project_reponame
            repo_path.to_s.split("/").last
          end

          def github_token
            ensure_configuration(:github_token)
          end
        end
      end
    end
  end
end
