# frozen_string_literal: true

require_relative "jiminy/version"
require_relative "jiminy/setup"
require_relative "jiminy/recording" if defined?(Rails)

module Jiminy
  module_function

  def reset_results_file!
    Jiminy::Recording.reset_results_file!
  end
end
