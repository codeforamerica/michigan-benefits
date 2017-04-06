class App < ApplicationRecord
  belongs_to :user
  has_many :documents, inverse_of: :app
  has_many :household_members

  delegate :full_name, to: :user

  PREFERENCES_FOR_INTERVIEW = [
    "Telephone interview",
    "In-person interview"
  ]

  def applicant
    household_members.find_or_create_by!(relationship: 'self')
  end

  def non_applicant_members
    household_members - [applicant]
  end

  def form
    Form.new(self)
  end

  def mailing_address
    [mailing_street, mailing_city, mailing_zip].join(", ")
  end
end
