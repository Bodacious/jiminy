# frozen_string_literal: true

module Jiminy
  module Recording
    abort("Jiminy::Recording must be run from a Rails app") unless defined?(Rails)

    module_function

    def reset_results_file!
      Rails.root.join(Jiminy.config.temp_file_location.dirname).mkpath
      File.write(Jiminy.config.temp_file_location, [].to_yaml)
    end
  end
end
