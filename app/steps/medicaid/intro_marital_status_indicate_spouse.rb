module Medicaid
  class IntroMaritalStatusIndicateSpouse < Step
    step_attributes(
      :member_id,
      :spouse_id,
      :spouse,
    )

    validate :spouse_present

    def spouse_present
      if spouse_id.blank?
        errors.add(:spouse, "Make sure you select a person")
      end
    end
  end
end
