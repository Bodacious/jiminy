module Jiminy
  module Recording
    class TmpFileRecorder
      require_relative "n_plus_one"

      def self.reset_results_file!
        Rails.root.join(
          Jiminy.config.temp_file_location.dirname
        ).mkpath
        File.write(Jiminy.config.temp_file_location,
          [].to_yaml
        )
      end

      def record(location:, queries:)
        yaml_content = File.read(Jiminy.config.temp_file_location)
        array = YAML.safe_load(yaml_content)
        n_plus_one = NPlusOne.new(location: location, queries: queries)
        unless location_in_array?(location, array) || filepath_ignored?(n_plus_one.file)
          array << n_plus_one.to_h
        end
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