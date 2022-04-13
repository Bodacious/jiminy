# frozen_string_literal: true

module Jiminy
  module Recording
    require "jiminy/recording/prosopite_ext/send_notifications_with_tmp_file"

    module RSpec
      require "prosopite"
      require "jiminy/recording/test_controller_concern"

      ::Prosopite.singleton_class.prepend ProsopiteExt::SendNotificationsWithTmpFile

      def wrap_rspec_example(example)
        Prosopite.tmp_file = true
        ActionController::Base.include(Jiminy::Recording::TestControllerConcern)
        example.run
        Prosopite.tmp_file = false
      end
      Jiminy.extend(self)
    end
  end
end
RSpec.configure do |config|
  config.before(:suite) { Jiminy.reset_results_file! }
  config.around do |example|
    Jiminy.wrap_rspec_example(example)
  end
end