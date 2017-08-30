# frozen_string_literal: true

class Success < Step
  step_attributes :email, :faxed_at

  validates :email,
    presence: { message: "Make sure to provide an email address" }

  def submitted_date
    if faxed_at.present?
      faxed_at.strftime("%m-%d-%Y")
    end
  end
end
