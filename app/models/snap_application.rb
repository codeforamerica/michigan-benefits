class SnapApplication < ApplicationRecord
  has_many :addresses

  def mailing_address
    addresses.where(mailing: true).first || NullAddress.new
  end
end
