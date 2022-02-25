# frozen_string_literal: true

require_relative "configuration"

Jiminy.extend(Jiminy::ConfigurationMethods)

load "./config/initializers/jiminy.rb"
