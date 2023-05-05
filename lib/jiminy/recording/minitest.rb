# frozen_string_literal: true

module Jiminy
  module Recording
    require "jiminy/recording/prosopite_ext/send_notifications_with_tmp_file"

    module Minitest
      require "prosopite"
      require "jiminy/recording/test_controller_concern"

      ::Prosopite.singleton_class.prepend ProsopiteExt::SendNotificationsWithTmpFile

      def before_setup
        super
        Prosopite.tmp_file = true
        ActionController::Base.include(Jiminy::Recording::TestControllerConcern)
        ActionController::Api.include(Jiminy::Recording::TestControllerConcern)
      end

      def after_teardown
        super
        Prosopite.tmp_file = false
      end

      Jiminy.extend(self)
    end
  end
end

class MiniTest::Test
  include Jiminy::Recording::Minitest
end
