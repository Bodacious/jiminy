# frozen_string_literal: true

module Jiminy
  class Configuration
    DEFAULT_CONFIG_READER = -> { instance_variable_get(:"@_#{__callee__}" || raise_missing_required(__callee__)) }
    DEFAULT_CONFIG_WRITER = ->(value) { instance_variable_set(:"@_#{__callee__}"[0..-2], value) }

    class MissingConfigError < StandardError
      attr_reader :missing_config_name

      def initialize(missing_config_name)
        super()
        @missing_config_name = missing_config_name
      end

      def message
        <<~MESSAGE
          You must provide a configuration value for ##{missing_config_name}

          This probably means you haven't set Jiminy.config.#{missing_config_name}
        MESSAGE
      end
    end

    class << self
      def define_config(name, options = {})
        define_method(:"#{name}=", DEFAULT_CONFIG_WRITER)
        define_method(name.to_sym, DEFAULT_CONFIG_READER)
        defined_configs[name].merge!(options)
      end

      def defined_configs
        @_defined_configs ||= Hash.new { |hash, key| hash[key] = { default: nil, required: true } }
      end
    end

    define_config :ci_workflow_name, default: "build"

    define_config :circle_ci_api_token

    define_config :github_token

    define_config :ignore_file_path, default: File.join("./jiminy_ignores.yml")

    define_config :project_reponame

    define_config :project_username

    define_config :temp_file_location, default: File.join("./tmp/jiminy/results.yml")

    def initialize
      apply_defaults!
    end

    def repo_path
      [project_username, project_reponame].join("/")
    end

    private

    def defined_configs_with_defaults
      self.class.defined_configs.select { |_config_name, options| options[:default] }
    end

    def required_configs
      self.class.defined_configs.select { |_config_name, options| options[:required] }
    end

    def apply_defaults!
      defined_configs_with_defaults.each do |config_name, options|
        public_send(:"#{config_name}=", options[:default])
      end
    end

    def raise_missing_required(config_name)
      return unless required_configs.key?(config_name)

      raise MissingConfigError, config_name
    end
  end

  module ConfigurationMethods
    def configure(&block)
      block.call(configuration)
    end

    def configuration
      @_configuration ||= Configuration.new
    end

    alias config configuration

    def configured?
      !!configuration
    end
  end
end
