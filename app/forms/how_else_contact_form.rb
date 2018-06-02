class HowElseContactForm < Form
  set_attributes_for :application,
                     :postal_mail, :phone_call,
                     :sms_consented, :email_consented
end
