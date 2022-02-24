module Jiminy
  module Reporting
    class NPlusOne
      require "erb"

      TEMPLATE_PATH = File.expand_path("n_plus_one_instance.md.erb", __dir__)

      # https://docs.ruby-lang.org/en/2.3.0/ERB.html#method-c-new
      ERB_SAFE_LEVEL = nil

      attr_reader :file, :line, :method, :examples

      attr_accessor :blob_url

      def initialize(file:, line:, method:, examples: [])
        @file = file
        @line = line
        @examples = examples
      end

      def to_markdown
        ERB.new(markdown_template, trim_mode: "-").result(binding)
      end

      def blob_url_with_line
        "#{blob_url}#L#{line}"
      end

      private

        def markdown_template
          @_markdown_template ||= File.read(TEMPLATE_PATH)
        end
    end
  end
end