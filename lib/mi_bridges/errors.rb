module MiBridges
  class Error < StandardError
    attr_reader :message

    def initialize(message)
      @message = message
    end
  end

  module Errors
    class PageNotFoundError < MiBridges::Error; end

    class TooManyAttempts < MiBridges::Error; end
  end
end
