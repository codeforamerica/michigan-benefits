module MiBridges
  class Driver
    class HealthHospitalizationInsurancePremiumsPage < ClickNextPage
      def self.title
        /(.*)'s Health\/hospitalization insurance premiums/
      end
    end
  end
end
