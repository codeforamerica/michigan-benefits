class App < ApplicationRecord
  belongs_to :user

  def mailing_address
    [mailing_street, mailing_city, mailing_zip].join(", ")
  end
end
