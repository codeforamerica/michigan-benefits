# frozen_string_literal: true

module Medicaid
  class ContactSocialSecurity < Step
    include MultiparameterAttributeAssignment
    extend AutoStripAttributes
    include SocialSecurityNumber

    step_attributes(
      :ssn,
      :birthday,
    )

    # https://github.com/rails/rails/pull/8189#issuecomment-10329403
    def class_for_attribute(attr)
      return Date if attr == "birthday"
    end
  end
end
