module Jiminy
  class Configuration
    attr_writer :circle_ci_api_token
    attr_writer :github_ref
    attr_writer :temp_file_location
    attr_writer :ignore_file_path

    def temp_file_location
      @temp_file_location || Rails.root.join("tmp/jiminy/results.yml")
    end

    def ignore_file_path
      @ignore_file_path || Rails.root.join("config/jiminy_ignores.yml")
    end

    def circle_ci_api_token
      @circle_ci_api_token || ENV["CIRCLE_CI_API_TOKEN"]
    end

    def github_repository
      @github_repository || ENV["GITHUB_REPOSITORY"]
    end

    def github_ref
      @github_ref || ENV["GITHUB_REF"].to_s.match(/refs\/pull\/(\d+)\//)[1]
    end
  end

  module ConfigurationMethods
    def configuration
      @_configuration ||= Configuration.new
    end

    alias config configuration
  end
end