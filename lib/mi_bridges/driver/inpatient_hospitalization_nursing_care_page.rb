module MiBridges
  class Driver
    class InpatientHospitalizationNursingCarePage < ClickNextPage
      def self.title
        /(.*)'s Inpatient Hospitalization\/Nursing Care/
      end
    end
  end
end
