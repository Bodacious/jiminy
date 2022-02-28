# frozen_string_literal: true

module Jiminy
  module Reporting
    module Reporters
      class DryRunReporter < BaseReporter
        def report!
          $stdout.puts report_body
        end
      end
    end
  end
end
