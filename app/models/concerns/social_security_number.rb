module SocialSecurityNumber
  extend ActiveSupport::Concern

  SSN_REGEX = /\A\d{9}\z/

  included do
    auto_strip_attributes :ssn

    validates :ssn,
      allow_blank: true,
      format: {
        with: SSN_REGEX,
        message: "Make sure to provide 9 digits",
      }
  end
end
