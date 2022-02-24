module NPlusOneReporting
  module CIProviders
    class ProviderConfiguration
      private

        def ensure_env_variable(name)
          value = ENV[name.to_s].to_s
          return value unless value.empty?

          raise("Please provide a value for #{name}")
        end
    end
  end
end
