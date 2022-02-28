# frozen_string_literal: true

module Jiminy
  module Reporting
    module Reporters
      class GithubReporter < BaseReporter
        require "jiminy/github_apiable"

        include GithubAPIable

        def initialize(header:, body:, pr_number:)
          super(header: header, body: body)
          @pr_number = pr_number
        end

        def report!
          client.add_comment(env_config.repo_path, pr_number, comment_body)
        end

        private

        attr_reader :pr_number

        alias comment_body report_body
      end
    end
  end
end
