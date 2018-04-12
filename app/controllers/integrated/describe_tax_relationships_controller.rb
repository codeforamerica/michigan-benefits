module Integrated
  class DescribeTaxRelationshipsController < MultipleMembersPerPageController
    def self.skip?(application)
      application.single_member_household? ||
        application.primary_member.filing_taxes_next_year_no? ||
        !application.navigator.anyone_else_on_tax_return?
    end

    private

    def members_to_update
      current_application.non_applicant_members
    end
  end
end
