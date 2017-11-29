module Submittable
  extend ActiveSupport::Concern

  included do
    has_many :exports, as: :benefit_application, dependent: :destroy
  end

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

  def close_pdf
    if @pdf.present? && @pdf.respond_to?(:close)
      @pdf.close
      @pdf.unlink
    end
  end
end
