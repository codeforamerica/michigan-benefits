module Integrated
  class FileTaxesNextYearController < FormsController
    def self.skip?(application)
      return true if application.healthcare_applying_members.count < 1
      return true unless application.primary_member.requesting_healthcare_yes?
    end

    def update_models
      member_data = member_params
      if member_data[:filing_taxes_next_year] == "yes"
        member_data[:tax_relationship] = "primary"
      end
      current_application.primary_member.update!(member_data)
    end
  end
end
