# frozen_string_literal: true

module Jiminy
  module Reporting
    module CIProviders
      module Local
        class Artifact
          attr_accessor :url

          def self.all
            Dir[Jiminy.configuration.temp_file_location].map do |filepath|
              new(url: filepath)
            end
          end

          def initialize(attributes)
            attributes.each do |key, value|
              public_send(:"#{key}=", value)
            end
          end
        end
      end
    end
  end
end
