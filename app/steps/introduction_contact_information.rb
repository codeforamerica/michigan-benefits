# frozen_string_literal: true

class IntroductionContactInformation < SimpleStep
  step_attributes :phone_number,
    :accepts_text_messages,
    :email,
    :mailing_street,
    :mailing_city,
    :mailing_zip,
    :mailing_address_same_as_home_address

  validates :email,
    format: {
      with: /\A.+@.+\..+\z/,
      message: 'Make sure you enter a valid email address'
    },
    allow_blank: true

  validates :phone_number,
    length: { is: 10, message: 'Make sure your phone number is 10 digits long' }

  validates :mailing_zip,
    length: { is: 5, message: 'Make sure your ZIP code is 5 digits long' },
    allow_blank: true

  validates \
    :accepts_text_messages,
    :mailing_address_same_as_home_address,
    presence: { message: 'Make sure to answer this question' }

  before_validation :strip_non_digits_from_phone_number

  def strip_non_digits_from_phone_number
    self.phone_number = phone_number.remove(/[^\d]/)
  end
end
