module PdfAttributes
  extend ActiveSupport::Concern

  def bool_to_checkbox(statement)
    if statement
      "Yes"
    end
  end

  def yes_no(statement)
    statement ? "yes" : "no"
  end

  def residential_or_homeless
    if benefit_application.stable_housing?
      full_street_address(benefit_application.residential_address)
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

  def full_street_address(address)
    [address.street_address, address.street_address_2].reject(&:blank?).join(", ")
  end
end
