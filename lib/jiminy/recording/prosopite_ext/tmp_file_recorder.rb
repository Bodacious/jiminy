# frozen_string_literal: true

module Jiminy
  module Recording
    module ProsopiteExt
      class TmpFileRecorder
        require_relative "../n_plus_one"

        def record(location:, queries:)
          yaml_content = File.read(Jiminy.config.temp_file_location)
          array = YAML.safe_load(yaml_content)
          n_plus_one = NPlusOne.new(location: location, queries: queries)

          array << n_plus_one.to_h unless location_in_array?(location, array) || filepath_ignored?(n_plus_one.file)
          File.write(Jiminy.config.temp_file_location, array.to_yaml)
        end

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
