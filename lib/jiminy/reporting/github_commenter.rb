module NPlusOneReporting
  class GithubCommenter
    require "jiminy/github_apiable"

    include GithubAPIable

    attr_reader :header, :body

    def initialize(header:, body:)
      @header = header
      @body   = body
    end

    def report!
      client.add_comment(env_config.repo_path, env_config.pr_number, comment_body)
    end

    private

      def comment_body
        "#{header}\n\n#{body}"
      end
  end
end
