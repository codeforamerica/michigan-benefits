module Medicaid
  class IntroName < Step
    include MultiparameterAttributeAssignment

    step_attributes(
      :first_name,
      :last_name,
      :sex,
      :birthday,
    )

    validates :first_name,
      presence: { message: "Make sure to provide a first name" }

    validates :last_name,
      presence: { message: "Make sure to provide a last name" }

    validates :sex, inclusion: {
      in: %w(male female),
      message: "Make sure to answer this question",
    }

    validates :birthday,
      presence: { message: "Make sure to provide a birthday" }

    # https://github.com/rails/rails/pull/8189#issuecomment-10329403
    def class_for_attribute(attr)
      return Date if attr == "birthday"
    end
  end
end
