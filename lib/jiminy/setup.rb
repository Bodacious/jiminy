require_relative "configuration"
module Jiminy
  module Setup
    Jiminy.extend(ConfigurationMethods)
  end
end