module Jiminy
  module Reporting
    module CIProviders
      module CircleCI
        class VCS < Base
          define_attribute_readers :revision
        end
      end
    end
  end
end