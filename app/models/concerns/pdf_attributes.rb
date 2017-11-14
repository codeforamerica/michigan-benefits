module PdfAttributes
  extend ActiveSupport::Concern

  def bool_to_checkbox(statement)
    if statement == true
      "Yes"
    end
  end

  def residential_or_homeless
    if benefit_application.stable_housing?
      benefit_application.residential_address.street_address
    else
      "Homeless"
    end
  end

  def phone_attributes
    if benefit_application.phone_number.nil?
      {}
    else
      ten_digit_phone.each_with_index.reduce({}) do |memo, (phone_digit, index)|
        memo["phone_number_#{index}"] = phone_digit
        memo
      end
    end
  end

  def ten_digit_phone
    benefit_application.phone_number.split("")
  end
end
