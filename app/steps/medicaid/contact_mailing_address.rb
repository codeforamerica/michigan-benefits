# frozen_string_literal: true

module Medicaid
  class ContactMailingAddress < Step
    step_attributes(
      :mailing_street_address,
      :mailing_city,
      :mailing_zip,
    )
  end
end
