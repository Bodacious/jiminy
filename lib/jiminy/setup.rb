# frozen_string_literal: true

require_relative "configuration"

Jiminy.extend(Jiminy::ConfigurationMethods)

begin
  load "./config/jiminy.rb"
rescue LoadError; nil
end
