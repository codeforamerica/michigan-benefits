module Medicaid
  class InsuranceCurrentType < Step
    step_attributes(
      :insurance_type,
      :member_id,
    )

    def valid?
      if member_has_insurance? && no_insurance_type_provided?
        errors.add(:insurance_type, "Please select a plan")
        false
      else
        true
      end
    end

    private

    def member_has_insurance?
      member.requesting_health_insurance? && member.insured?
    end

    def no_insurance_type_provided?
      insurance_type.blank?
    end

    def member
      @_member ||= Member.find(member_id)
    end
  end
end
