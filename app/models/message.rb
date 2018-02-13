class Message
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :phone

  ACCEPTABLE_PHONE_NUMBERS = %w{
    8177136264
    8314207603
    8487024594
  }

  validates :phone, inclusion: { in: ACCEPTABLE_PHONE_NUMBERS }

end