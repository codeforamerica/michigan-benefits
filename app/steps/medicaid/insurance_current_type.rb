module Medicaid
  class InsuranceCurrentType < MemberStep
    step_attributes(
      :insurance_type,
      :id,
    )

    INSURANCE_TYPES = {
      "Medicaid" => "Medicaid",
      "Medicare" => "Medicare",
      "CHIP/MIChild" => "CHIP/MIChild",
      "VA health care programs" => "VA health care programs",
      "Employer or individual plan" =>
        "Policy through an employer or individual plan",
      "Other" => "Other",
    }.freeze

    validate :insurance_plan_selected

    def insurance_plan_selected
      if member_has_insurance? && no_insurance_type_provided?
        errors.add(:insurance_type, "Make sure you select a plan")
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
