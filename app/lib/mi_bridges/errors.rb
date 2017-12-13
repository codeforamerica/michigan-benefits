module MiBridges
  class Error < StandardError
  end

  module Errors
    class PageNotFoundError < MiBridges::Error; end

    class TooManyAttempts < MiBridges::Error; end

    class StepNotFoundError < MiBridges::Error; end
  end
end
