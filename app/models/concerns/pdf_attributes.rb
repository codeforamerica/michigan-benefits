module PdfAttributes
  CIRCLED = "O".freeze
  UNDERLINED = "––––––––––".freeze

  def to_h
    attributes.
      reduce { |accum, attribute_hash| accum.merge(attribute_hash) }.
      symbolize_keys
  end

  def bool_to_checkbox(statement)
    if statement
      "Yes"
    end
  end

  def yes_no(statement)
    statement ? "yes" : "no"
  end

  def yes_no_checkbox(field_name, boolean_value)
    { "#{field_name}_#{yes_no(boolean_value)}".to_sym => "Yes" }
  end

  def mmddyyyy_date(date)
    date&.strftime("%m/%d/%Y")
  end

  def first_names(members)
    members.pluck(:first_name).join(", ")
  end

  def dependents
    @_dependents ||= benefit_application.members.dependents
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

  def formatted_phone
    ph = benefit_application.phone_number
    "(#{ph[0..2]}) #{ph[3..5]}-#{ph[6..9]}"
  end
end
