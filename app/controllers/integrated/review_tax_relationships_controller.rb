module Integrated
  class ReviewTaxRelationshipsController < FormsController
    def self.skip?(application)
      application.primary_member.filing_taxes_next_year_no?
    end

    def edit
      @primary_member = current_application.primary_member
      @tax_household_members = current_application.tax_household_members
      @non_tax_household_members = current_application.members - current_application.tax_household_members
    end

    def form_class
      NullStep
    end
  end
end
