module Jiminy
  module Recording

    unless defined?(Rails)
      abort("Jiminy::Recording should be run from a Rails app")
    end
  end
end
