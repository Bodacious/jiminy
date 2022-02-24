module NPlusOneReporting
  class YAMLFileInstancePresenter
    require "open-uri"
    require "yaml"
    require "jiminy/github_apiable"

    class MissingFileError < StandardError; end

    include GithubAPIable
    include URI

    INSTANCE_SEPARATOR = "\n".freeze

    attr_reader :source_filepath

    def initialize(source_filepath)
      @source_filepath = source_filepath
    end

    def comment_body
      @_comment_body ||= build_comment_body
    end

    alias_method :to_s, :comment_body

    private

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
        if source_filepath.start_with?("https://")
          return file_content_for_remote_file(source_filepath)
        end

        file_content_for_local_file(source_filepath)
      end

      def file_content_for_remote_file(source_filepath)
        URI.parse(source_filepath).open({ "Circle-Token" => ENV["CIRCLE_CI_API_TOKEN"] }).read
      end

      def file_content_for_local_file(source_filepath)
        File.read(source_filepath)
      end

      def build_comment_body
        instances.map do |instance|
          file = file_from_instance(instance)
          instance.blob_url = file.blob_url
          instance.to_markdown
        end.join(INSTANCE_SEPARATOR)
      end

      def file_from_instance(instance)
        client.pull_request_files(env_config.repo_path, env_config.pr_number).detect do |file|
          file.filename == instance.file
        end or raise(MissingFileError)
      end
  end
end
