# frozen_string_literal: true

module Jiminy
  module Recording
    module TestControllerConcern
      extend ActiveSupport::Concern

      included do
        around_action :_test_n_plus_one_detection
      end

      private

        def _test_n_plus_one_detection
          yield and return if Prosopite.scan?

          begin
            Prosopite.scan
            yield
          ensure
            Prosopite.finish
          end
        end
    end
  end
end
