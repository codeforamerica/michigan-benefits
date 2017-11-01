module SocialSecurityNumber
  extend ActiveSupport::Concern

  SSN_REGEX = /\A\d{4}\z/

  included do
    auto_strip_attributes :last_four_ssn

    validates :last_four_ssn,
      allow_blank: true,
      format: {
        with: SSN_REGEX,
        message: "Make sure to provide the last 4 digits",
      }
  end
end
