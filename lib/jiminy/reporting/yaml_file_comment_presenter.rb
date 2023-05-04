# frozen_string_literal: true

module Jiminy
  module Reporting
    class YAMLFileCommentPresenter
      require "open-uri"
      require "yaml"
      require "jiminy/github_apiable"

      include GithubAPIable

      INSTANCE_SEPARATOR = "\n"

      def initialize(source_filepath:, pr_number:)
        @source_filepath = source_filepath
        @pr_number = pr_number
      end

      def comment_body
        @_comment_body ||= build_comment_body
      end

      alias to_s comment_body

      private

        attr_reader :source_filepath, :pr_number

        def instances
          @_instances ||= YAML.safe_load(file_content).map do |hash|
            options = hash.values.first.transform_keys!(&:to_sym)
            NPlusOne.new(**options)
          end
        end

        def file_content
          @_file_content ||= file_content_for_filepath(source_filepath)
        end

        def file_content_for_filepath(source_filepath)
          return file_content_for_remote_file(source_filepath) if source_filepath.start_with?("https://")

          file_content_for_local_file(source_filepath)
        end

        def file_content_for_remote_file(source_filepath)
          URI.parse(source_filepath).open({ "Circle-Token" => ENV.fetch("CIRCLE_CI_API_TOKEN", nil) }).read
        end

        def file_content_for_local_file(source_filepath)
          File.read(source_filepath)
        end

        def build_comment_body
          Array(instances).map do |instance|
            file = file_from_instance(instance) || next
            instance.blob_url = file.blob_url
            instance.to_markdown
          end.compact.join(INSTANCE_SEPARATOR)
        end

        def file_from_instance(instance)
          client.pull_request_files(env_config.repo_path, pr_number).detect do |file|
            file.filename == instance.file
          end
        end
    end
  end
end
