# frozen_string_literal: true

module Jiminy
  module Recording
    class NPlusOne
      attr_reader :file, :location

      LOCATION_MATCHER = /(?<file>.+\.rb):
        (?<line>\d+):in\s`
        (?:block\sin\s)?
        (?<method_name>.+)'
      /x.freeze

      EXAMPLES_COUNT = 3

      def initialize(location:, queries: [])
        @location = location.to_s.strip
        @queries = queries
        match = location.match(LOCATION_MATCHER)
        @line = match[:line]
        @method_name = match[:method_name]
        @file = match[:file]
        freeze
      end

      def ==(other)
        location == other.location
      end

      def to_h
        {
          location => attributes
        }
      end

      private

        attr_reader :queries, :line, :method_name

        def attributes
          {
            "file" => file,
            "line" => line,
            "method" => method_name,
            "examples" => queries.take(EXAMPLES_COUNT)
          }
        end
    end
  end
end
