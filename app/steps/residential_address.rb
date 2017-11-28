class ResidentialAddress < Step
  step_attributes(
    :city,
    :state,
    :street_address,
    :street_address_2,
    :unstable_housing,
    :zip,
  )

  with_options if: :stable_housing? do |address|
    address.validates :street_address,
      presence: {
        message: "Make sure to provide a street address",
        allow_blank: false,
      }

    address.validates :city,
      presence: {
        message: "Make sure to provide a city",
        allow_blank: false,
      }

    address.validates :zip,
      length: {
        is: 5,
        message: "Make sure your ZIP code is 5 digits long",
      }
  end

  validates :state,
    inclusion: { in: %w(MI), message: "Make sure the state is MI" }

  private

  def stable_housing?
    unstable_housing == "0"
  end
end
