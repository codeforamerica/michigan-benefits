module Integrated
  class IncomeSourcesController < MemberPerPageController
    include TypeCheckbox

    helper_method :income_sources

    def income_sources
      if current_application.applying_for_food_assistance?
        AdditionalIncome::INCOME_SOURCES
      else
        AdditionalIncome::INCOME_SOURCES_HEALTHCARE_ONLY
      end
    end

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
