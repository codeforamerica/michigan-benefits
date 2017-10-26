# frozen_string_literal: true

module MiBridges
  class Driver
    class PrescriptionDrugsAndMedicationPage < ClickNextPage
      def self.title
        /(.*)'s Prescription drugs and over-the-counter medication/
      end
    end
  end
end
