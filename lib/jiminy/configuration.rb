module Jiminy
  class Configuration
    attr_accessor :circle_ci_api_token,
                  :repo_path,
                  :github_token

    attr_writer :github_ref,
                :ignore_file_path,
                :dry_run,
                :temp_file_location

    def temp_file_location
      @temp_file_location || Rails.root.join("tmp/jiminy/results.yml")
    end

    def ignore_file_path
      @ignore_file_path || Rails.root.join(".jiminy_ignores.yml")
    end

    def ci_test_platform
      :circle_ci
    end

    def vc_platform
      :github
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
  end
end