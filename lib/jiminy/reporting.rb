# frozen_string_literal: true

module Jiminy
  module Reporting
    require_relative "reporting/n_plus_one"
    require_relative "reporting/yaml_file_comment_presenter"
    require_relative "reporting/ci_providers"
    require_relative "reporting/dry_run_reporter"
    require_relative "reporting/github_commenter"

    TEMPLATES_DIR = File.expand_path("templates/reporting", __dir__).freeze

    COMMENT_HEADER = ERB.new(File.read(File.join(TEMPLATES_DIR, "comment_header.md.erb"))).result.freeze

    LINE_SEPARATOR = "\n"

    module_function

    def report!(*yaml_files, **options)
      comment_content = yaml_files.map do |yaml_file|
        YAMLFileCommentPresenter.new(source_filepath: yaml_file, pr_number: options[:pr_number]).to_s
      end.join(LINE_SEPARATOR)
      if options[:dry_run]
        DryRunReporter.new(header: COMMENT_HEADER, body: comment_content).report!
      else
        GithubCommenter.new(header: COMMENT_HEADER, body: comment_content, pr_number: options[:pr_number]).report!
      end
    end
  end
end
