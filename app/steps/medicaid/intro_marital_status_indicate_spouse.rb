module Medicaid
  class IntroMaritalStatusIndicateSpouse < Step
    step_attributes(
      :member_id,
      :spouse_id,
      :spouse,
    )

    def valid?
      if spouse_id.present?
        true
      else
        errors.add(:spouse, "Make sure you select a person")
        false
      end
    end

    def member
      @_member ||= Member.find(member_id)
    end
  end
end
