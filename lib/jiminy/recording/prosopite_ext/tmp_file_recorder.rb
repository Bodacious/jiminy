# frozen_string_literal: true

module Jiminy
  module Recording
    module ProsopiteExt
      class TmpFileRecorder
        require_relative "../n_plus_one"

        # rubocop:disable Metrics/AbcSize
        def record(location:, queries:)
          yaml_content = File.read(Jiminy.config.temp_file_location)
          array = YAML.safe_load(yaml_content)
          n_plus_one = NPlusOne.new(location: location, queries: queries)

          if filepath_ignored?(n_plus_one.file)
            Jiminy.logger.debug { "Ignoring n+1 instance #{n_plus_one}" }
            return
          end

          if location_in_array?(location, array)
            Jiminy.logger.debug { "Already reported n+1 instance #{n_plus_one}" }
            return
          end

          array << n_plus_one.to_h
          File.write(Jiminy.config.temp_file_location, array.to_yaml)
        end
        # rubocop:enable Metrics/AbcSize

        private

          def location_in_array?(location, array)
            array.detect { |hash| hash.key?(location) }
          end

          def filepath_ignored?(filepath)
            ignored_files.include?(filepath)
          end

          def ignored_files
            @_ignored_files ||= load_ignored_files
          end

          def load_ignored_files
            return [] unless File.exist?(Jiminy.config.ignore_file_path)

            YAML.load_file(Jiminy.config.ignore_file_path) || []
          end
      end
    end
  end
end
