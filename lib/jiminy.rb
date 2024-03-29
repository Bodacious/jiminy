# frozen_string_literal: true

require_relative "jiminy/version"
require_relative "jiminy/setup"
require_relative "jiminy/recording" if defined?(Rails)
require_relative "jiminy/rspec" if defined?(RSpec) && ENV["RAILS_ENV"] == "test"
require_relative "jiminy/minitest" if defined?(Minitest) && ENV["RAILS_ENV"] == "test"

module Jiminy
  module_function

  def reset_results_file!
    Jiminy::Recording.reset_results_file!
  end
end
