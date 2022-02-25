module Jiminy
  module GithubAPIable
    require "octokit"

    private

    def env_config
      @_env_config ||= Reporting::CIProviders::Github::Configuration.new
    end

    def client
      @_client ||= Octokit::Client.new(access_token: env_config.github_token)
    end
  end
end
