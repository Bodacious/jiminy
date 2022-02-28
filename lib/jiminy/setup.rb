# frozen_string_literal: true

require_relative "configuration"

Jiminy.extend(Jiminy::ConfigurationMethods)

begin
  load "./config/initializers/jiminy.rb"
rescue LoadError; nil
end
