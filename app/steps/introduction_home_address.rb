# frozen_string_literal: true

class IntroductionHomeAddress < Step
  step_attributes :home_address,
    :home_city,
    :home_zip,
    :unstable_housing

  validates :home_zip,
    length: { is: 5, message: 'Make sure your ZIP code is 5 digits long' },
    unless: ->(home_address) { home_address.unstable_housing.in? ['1', 'true', true] }

  validates \
    :home_address,
    :home_city,
    presence: { message: 'Make sure to answer this question' },
    unless: ->(home_address) { home_address.unstable_housing.in? ['1', 'true', true] }
end
