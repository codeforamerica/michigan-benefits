# frozen_string_literal: true

module MiBridges
  class Driver
    class PersonalCareServicesProvidedInHomePage < ClickNextPage
      def self.title
        /(.*)'s Personal care services provided in home/
      end
    end
  end
end
