module Jiminy
  class CLI
    module ExitCodes
      Base = Struct.new(:message, :value) do
        def to_s
          message
        end
      end
    end
  end
end
