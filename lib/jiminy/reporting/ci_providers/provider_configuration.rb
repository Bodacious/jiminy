# frozen_string_literal: true

module Jiminy
  module Reporting
    module CIProviders
      class ProviderConfiguration
        TEMPLATE_METHOD_PROC = -> { raise NotImplementedError, "Define #{__callee__} in #{self}" }

        define_method(:repo_path, TEMPLATE_METHOD_PROC)

        define_method(:project_username, TEMPLATE_METHOD_PROC)

        define_method(:project_reponame, TEMPLATE_METHOD_PROC)

        define_method(:github_token, TEMPLATE_METHOD_PROC)

        private

        def ensure_configuration(name)
          value = Jiminy.config.public_send(name)
          return value unless value.empty?

          raise("Please provide a value for Jiminy.config.#{name}")
        end
      end
    end
  end
end
