module Jiminy
  class Configuration
    attr_writer :temp_file_location
    attr_writer :ignore_file_path

    def temp_file_location
      @_temp_file_location ||= Rails.root.join("tmp/jiminy/results.yml")
    end

    def ignore_file_path
      @_ignore_file_path ||= Rails.root.join("config/jiminy_ignores.yml")
    end
  end
end