module Submittable
  extend ActiveSupport::Concern

  def receiving_office_name
    receiving_office.name
  end

  def receiving_office_email
    receiving_office.email
  end

  def receiving_office_phone_number
    receiving_office.phone_number
  end

  def receiving_office
    @receiving_office ||= OfficeRecipient.new(benefit_application: self)
  end
end
