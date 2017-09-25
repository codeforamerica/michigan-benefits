module MiBridges
  class Error < StandardError; end

  module Errors
    class PageNotFoundError < MiBridges::Error
      attr_reader :message

      def initialize(message)
        @message = message
      end
    end
  end
end
