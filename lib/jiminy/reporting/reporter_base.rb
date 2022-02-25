module Jiminy
  module Reporting
    class ReporterBase
      def initialize(header:, body:)
        @header = header
        @body   = body
      end

      def report!
        raise NotImplementedError, "Please define #{report!} in #{self}"
      end

      private

      attr_reader :header, :body

      def report_body
        "#{header}\n\n#{body}"
      end
    end
  end
end
