module Medicaid
  class InsuranceCurrentType < MemberStep
    step_attributes(
      :insurance_type,
      :member_id,
    )

    def valid?
      if member_has_insurance? && no_insurance_type_provided?
        errors.add(:insurance_type, "Make sure you select a plan")
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
  end
end
