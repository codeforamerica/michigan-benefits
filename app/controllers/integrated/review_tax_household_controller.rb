module Integrated
  class ReviewTaxHouseholdController < FormsController
    def self.custom_skip_rule_set(application)
      application.primary_member.requesting_healthcare_no? ||
        application.primary_member.filing_taxes_next_year_no?
    end

    def edit
      @primary_member = current_application.primary_member
      @non_applicant_members = current_application.non_applicant_members
    end

    def form_class
      NullStep
    end
  end
end
