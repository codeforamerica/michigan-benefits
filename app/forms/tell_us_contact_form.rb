class TellUsContactForm < Form
  set_attributes_for :application,
                     :sms_phone_number, :email

  validates :sms_phone_number,
            ten_digit_phone_number: true,
            phone: { allow_blank: true, message: I18n.t(:real_phone_number) }

  validates :email,
            allow_blank: true,
            format: {
              with: /\A\S+@\S+\.\S+\z/,
              message: "Make sure you enter a valid email address",
            }
end
