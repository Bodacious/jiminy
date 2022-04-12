# frozen_string_literal: true

module Jiminy
  module Reporting
    class NPlusOne
      require "erb"

      # https://docs.ruby-lang.org/en/2.3.0/ERB.html#method-c-new
      ERB_SAFE_LEVEL = nil

      TRIM_MODE = "-"

      attr_reader :file, :line, :method, :examples

      attr_accessor :blob_url

      def initialize(file:, line:, method:, examples: [])
        @examples = examples
        @file = file
        @line = line
        @method = method
      end

      def to_markdown
        ERB.new(markdown_template, trim_mode: TRIM_MODE).result(binding)
      end

      def blob_url_with_line
        "#{blob_url}#L#{line}"
      end

      private

        def markdown_template
          @_markdown_template ||= File.read(File.join(TEMPLATES_DIR, "n_plus_one.md.erb"))
        end
    end
  end
end
