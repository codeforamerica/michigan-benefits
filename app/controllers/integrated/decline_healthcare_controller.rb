module Integrated
  class DeclineHealthcareController < FormsController
    def self.skip?(application)
      application.healthcare_applying_members.count.positive?
    end

    def form_class
      NullStep
    end
  end
end
