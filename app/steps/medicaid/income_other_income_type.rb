# frozen_string_literal: true

module Medicaid
  class IncomeOtherIncomeType < Step
    step_attributes(
      :alimony,
      :other,
      :pension,
      :retirement,
      :social_security,
      :unemployment,
      :other_income_types,
      :member_id,
    )

    def valid?
      if member_has_other_income? && no_other_income_type_provided?
        errors.add(
          :other_income_types,
          "Please select at least one other income type",
        )
        false
      else
        true
      end
    end

    private

    def member_has_other_income?
      member.other_income?
    end

    def no_other_income_type_provided?
      other_income_types.empty?
    end

    def existing_attributes
      HashWithIndifferentAccess.new(current_member&.attributes)
    end

    def member
      @_member ||= Member.find(member_id)
    end
  end
end
