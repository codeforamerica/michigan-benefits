class SnapApplication < ApplicationRecord
  has_many :addresses
  has_many :members

  def mailing_address
    addresses.where(mailing: true).first || NullAddress.new
  end
end
