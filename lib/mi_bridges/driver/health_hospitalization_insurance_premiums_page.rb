# frozen_string_literal: true

module MiBridges
  class Driver
    class HealthHospitalizationInsurancePremiumsPage < ClickNextPage
      TITLE = /(.*)'s Health\/hospitalization insurance premiums/
    end
  end
end
