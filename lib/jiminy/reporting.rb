module Jiminy
  module Reporting
    require_relative "reporting/n_plus_one"
    require_relative "reporting/yaml_file_instance_presenter"
    require_relative "reporting/github_commenter"
    require_relative "reporting/ci_providers"

    COMMENT_HEADER = <<~MARKDOWN.freeze
      It looks like the following changes might have introduced new N+1 queries.
      Please investigate this issue before merging these changes into `main`.

      (You can ignore this issue by adding the file path to `config/n_plus_one_ignores.yml`)

    MARKDOWN

    module_function

    def report!(*yaml_files)
      comment_content = yaml_files.map { |yaml_file| YAMLFileInstancePresenter.new(yaml_file).to_s }
      GithubCommenter.new(header: COMMENT_HEADER, body: comment_content.join("\n")).report!
    end
  end
end
