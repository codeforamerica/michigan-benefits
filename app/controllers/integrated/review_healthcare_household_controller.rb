module Integrated
  class ReviewHealthcareHouseholdController < FormsController
    def self.custom_skip_rule_set(application)
      application.primary_member.requesting_healthcare_no?
    end

    def edit
      @primary_member = current_application.primary_member
      non_applicant_members = current_application.non_applicant_members
      if current_application.primary_member.filing_taxes_next_year_yes?
        @removed_household_members = non_applicant_members.select(&:tax_relationship_not_included?)
        @removable_members = non_applicant_members - @removed_household_members
      else
        @removable_members = non_applicant_members
        @removed_household_members = []
      end
      @show_remove_links = @primary_member.filing_taxes_next_year_yes? ||
        !current_application.navigator.applying_for_food?
    end

    def form_class
      NullStep
    end
  end
end
