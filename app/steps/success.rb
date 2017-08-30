# frozen_string_literal: true

class Success < Step
  step_attributes :email, :signed_at

  validates :email,
    presence: { message: "Make sure to provide an email address" }

  def submitted_date
    if signed_at.present?
      signed_at.strftime("%m-%d-%Y")
    end
  end
end
