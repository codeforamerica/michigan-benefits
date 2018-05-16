module Integrated
  class IncludeAnyoneElseOnTaxesController < FormsController
    def self.skip?(application)
      application.single_member_household? || application.primary_member.filing_taxes_next_year_no?
    end

    def update_models
      current_application.navigator.update(params_for(:navigator))
    end
  end
end
