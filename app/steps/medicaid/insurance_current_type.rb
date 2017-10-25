# frozen_string_literal: true

module Medicaid
  class InsuranceCurrentType < Step
    step_attributes(
      :insurance_type,
      :members,
    )

    def insured_members_requesting_insurance
      members.select(&:requesting_health_insurance).select(&:is_insured)
    end

    def valid?
      if requesting_members_valid?
        true
      else
        errors.add(
          :insurance_type,
          error_message,
        )
        false
      end
    end

    private

    def requesting_members_valid?
      insured_members_requesting_insurance.all? do |m|
        m.insurance_type.present?
      end
    end

    def error_message
      if insured_members_requesting_insurance.count == 1
        "Please select a plan"
      else
        "Please select a plan for each person"
      end
    end
  end
end
