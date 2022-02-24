# frozen_string_literal: true

require_relative "jiminy/version"
require_relative "jiminy/configuration"
require "jiminy/recording/tmp_file_recorder"
require "jiminy/reporting"

module Jiminy
  module_function

  def reset_results_file!
    Jiminy::Recording::TmpFileRecorder.reset_results_file!
  end

  def configuration
    @_configuration ||= Configuration.new
  end

  def config
    configuration
  end
end
