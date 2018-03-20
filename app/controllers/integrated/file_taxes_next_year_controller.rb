module Integrated
  class FileTaxesNextYearController < FormsController
    def self.skip?(application)
      return true if application.healthcare_applying_members.count < 1
      return true unless application.primary_member.requesting_healthcare_yes?
    end

    def update_models
      current_application.primary_member.update!(member_params)
    end
  end
end
