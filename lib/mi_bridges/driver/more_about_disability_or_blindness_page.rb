module MiBridges
  class Driver
    class MoreAboutDisabilityOrBlindnessPage < ClickNextPage
      def self.title
        /More About (.*)'s Disability or Blindness/
      end
    end
  end
end
