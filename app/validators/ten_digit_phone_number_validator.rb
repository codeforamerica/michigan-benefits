class TenDigitPhoneNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.blank? || value&.match?(/\A\d{10}\z/)
      record.errors[attribute] <<
        "Make sure your phone number is 10 digits long"
    end
  end
end
