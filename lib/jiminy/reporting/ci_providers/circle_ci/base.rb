module Jiminy
  module Reporting
    module CIProviders
      module CircleCI
        require "ostruct"
        require_relative "api_request"

        class Base
          require "uri"
          require "net/http"
          require "json"

          attr_reader :attributes

          def self.define_attribute_readers(*attr_names)
            attr_names.each do |attr_name|
              define_method(attr_name, -> { attributes[__callee__.to_s] })
            end
          end

          class << self
            attr_reader :next_token
          end

          class << self
            attr_writer :next_token
          end

          def self.fetch_api_resource(path)
            response = APIRequest.new(path).perform!
            if response.is_a?(Net::HTTPOK)
              json_body = JSON.parse(response.read_body)
              self.next_token = json_body["next_page_token"]
              json_body["items"].map { |attributes| new(attributes) }
            else
              raise "Error response: #{response.body}"
            end
          end

          def initialize(attributes = {})
            @attributes = attributes.transform_keys!(&:to_s)
          end
        end
      end
    end
  end
end
