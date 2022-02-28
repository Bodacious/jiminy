# frozen_string_literal: true

module Jiminy
  module Reporting
    module Reporters
      require_relative "reporters/base_reporter"
      require_relative "reporters/dry_run_reporter"
      require_relative "reporters/github_reporter"
    end
  end
end