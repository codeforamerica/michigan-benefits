class TellUsAuthorizedRepForm < Form
  set_attributes_for :application,
                     :authorized_representative_name, :authorized_representative_phone

  validates :authorized_representative_name,
    presence: { message: "Please provide their name" }

  validates :authorized_representative_phone,
    ten_digit_phone_number: true,
    phone: { allow_blank: false,
             message: "Please provide a valid 10 digit phone number, including area code" }
end
