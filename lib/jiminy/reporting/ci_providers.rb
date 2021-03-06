# frozen_string_literal: true

module Jiminy
  module Reporting
    module CIProviders
      require_relative "ci_providers/provider_configuration"
      require_relative "ci_providers/circle_ci"
      require_relative "ci_providers/github"
      require_relative "ci_providers/local"
    end
  end
end
