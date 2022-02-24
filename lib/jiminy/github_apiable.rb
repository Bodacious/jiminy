module NPlusOneReporting
  module GithubAPIable
    require "octokit"

    private

      def env_config
        @_env_config ||= CIProviders::Github::Configuration.new
      end

      def client
        @_client ||= Octokit::Client.new(access_token: env_config.github_access_token)
      end
  end
end
