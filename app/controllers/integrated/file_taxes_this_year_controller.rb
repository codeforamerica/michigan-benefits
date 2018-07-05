module Integrated
  class FileTaxesThisYearController < FormsController
    def self.custom_skip_rule_set(application)
      application.primary_member.requesting_healthcare_no?
    end

    def update_models
      member_data = params_for(:member)
      if member_data[:filing_taxes_next_year] == "yes"
        member_data[:tax_relationship] = "primary"
      end
      current_application.primary_member.update!(member_data)
    end
  end
end
