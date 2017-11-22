module Medicaid
  class IncomeOtherIncomeType < MemberStep
    step_attributes(
      :alimony,
      :other,
      :pension,
      :retirement,
      :social_security,
      :unemployment,
      :other_income_types,
      :id,
    )

    validate :income_type_selected

    def income_type_selected
      if member_has_other_income? && no_other_income_type_provided?
        errors.add(
          :other_income_types,
          "Please select at least one other income type",
        )
      end
    end

    private

    def member_has_other_income?
      member.other_income?
    end

    def no_other_income_type_provided?
      other_income_types.empty?
    end
  end
end
