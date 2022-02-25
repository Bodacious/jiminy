module Jiminy
  module Recording
    module ProsopiteExt
      require_relative "../tmp_file_recorder"

      module SendNotificationsWithTmpFile
        def prepare_results_file!
          TmpFileRecorder.prepare_results_file!
        end

        def tmp_file=(value)
          @tmp_file = value
        end

        def tmp_file
          !!@tmp_file
        end

        def send_notifications
          super
          if Prosopite.tmp_file
            tc[:prosopite_notifications].each do |queries, backtrace|
              absolute_location = backtrace.detect { |path| path.exclude?(Bundler.bundle_path.to_s) }
              next unless absolute_location

              relative_location = absolute_location.gsub("#{Rails.root.realpath}/", "")
              tmp_file_recorder.record(location: relative_location, queries: queries)
            end
          end
        end

        private

        def tmp_file_recorder
          @_tmp_file_recorder ||= TmpFileRecorder.new
        end
      end
    end
  end
end
