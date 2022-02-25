module Jiminy
  module Reporting
    require_relative "reporter_base"
    class DryRunReporter < ReporterBase
      def report!
        $stdout.puts report_body
      end
    end
  end
end
