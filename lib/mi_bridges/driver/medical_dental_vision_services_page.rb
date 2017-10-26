# frozen_string_literal: true

module MiBridges
  class Driver
    class MedicalDentalVisionServicesPage < ClickNextPage
      def self.title
        /(.*)'s Medical, dental and vision services/
      end
    end
  end
end
