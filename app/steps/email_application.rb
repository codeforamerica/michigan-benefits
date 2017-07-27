# frozen_string_literal: true

class EmailApplication < Step
  step_attributes :email

  validates :email,
    presence: { message: "Make sure to provide an email address" }
end
