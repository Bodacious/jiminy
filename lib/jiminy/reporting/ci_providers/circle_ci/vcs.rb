# frozen_string_literal: true

module Jiminy
  module Reporting
    module CIProviders
      module CircleCI
        class VCS < Base
          define_attribute_readers :revision, :review_url
        end
      end
    end
  end
end
