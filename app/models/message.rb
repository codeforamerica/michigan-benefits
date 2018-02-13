class Message < ApplicationRecord
  ACCEPTABLE_PHONE_NUMBERS = %w{
    8177136264
    8314207603
    8487024594
  }.freeze

  validates :phone, inclusion: { in: ACCEPTABLE_PHONE_NUMBERS }
  validates_presence_of :body
end
