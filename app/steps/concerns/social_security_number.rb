module SocialSecurityNumber
  extend ActiveSupport::Concern

  SSN_REGEX = /\A\d{9}\z/

  included do
    auto_strip_attributes :ssn

    validates :ssn,
      allow_blank: true,
      format: {
        with: SSN_REGEX,
        message: "Make sure your SSN has 9 digits",
      }

    # Overriding @record[key]=val, that's only found in ActiveRecord, so we can
    # use auto_strip_attributes with ActiveModel
    def []=(key, val)
      # send("#{key}=", val)  # We dont want to call setter again
      instance_variable_set(:"@#{key}", val)
    end

    def [](key)
      k = :"@#{key}"
      instance_variable_defined?(k) ? instance_variable_get(k) : nil
    end
  end
end
