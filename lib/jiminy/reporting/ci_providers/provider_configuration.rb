module Jiminy
  module Reporting
    module CIProviders
      class ProviderConfiguration
        TEMPLATE_METHOD_PROC = -> { raise NotImplementedError, "Define #{__callee__} in #{self}" }

        define_method(:repo_path, TEMPLATE_METHOD_PROC)

        define_method(:pr_number, TEMPLATE_METHOD_PROC)

        define_method(:project_username, TEMPLATE_METHOD_PROC)

        define_method(:project_reponame, TEMPLATE_METHOD_PROC)

        define_method(:github_access_token, TEMPLATE_METHOD_PROC)

        private

          def ensure_env_variable(name)
            value = ENV[name.to_s].to_s
            return value unless value.empty?

            raise("Please provide a value for #{name}")
          end
      end
    end
  end
end