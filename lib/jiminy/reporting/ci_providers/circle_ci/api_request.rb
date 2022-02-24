module Jiminy
  module Reporting
    module CIProviders
      module CircleCI
        class APIRequest
          attr_reader :url

          API_BASE = "https://circleci.com/api/v2/".freeze

          def initialize(path)
            @url = URI.join(API_BASE, path)
          end

          def perform!
            response
          end

          private

            def response
              @_response ||= http.request(request)
            end

            def request
              @_request ||= Net::HTTP::Get.new(url).tap do |req|
                req["Circle-Token"] = Jiminy.config.circle_ci_api_token
              end
            end

            def http
              @_http ||= Net::HTTP.new(url.host, url.port).tap do |http_instance|
                http_instance.use_ssl = true
                http_instance.verify_mode = OpenSSL::SSL::VERIFY_NONE
              end
            end
        end
      end
    end
  end
end