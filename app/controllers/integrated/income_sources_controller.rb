module Integrated
  class IncomeSourcesController < MemberPerPageController
    include TypeCheckbox

    def checkbox_attribute
      :income_type
    end

    def checkbox_options
      AdditionalIncome::INCOME_SOURCES.keys
    end

    def checkbox_collection
      current_member.additional_incomes
    end
  end
end
