# frozen_string_literal: true

module Medicaid
  class InsuranceCurrentType < Step
    step_attributes(
      :insurance_type,
      :members,
    )

    def insured_members
      members.select(&:is_insured)
    end

    def valid?
      if insured_members.all? { |m| m.insurance_type.present? }
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

    def error_message
      if members.select(&:is_insured).count == 1
        "Please select a plan"
      else
        "Please select a plan for each person"
      end
    end
  end
end
