# frozen_string_literal: true

module Jiminy
  module Reporting
    module Reporters
      class BaseReporter
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
end
