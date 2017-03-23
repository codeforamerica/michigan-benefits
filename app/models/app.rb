class App < ApplicationRecord
  belongs_to :user

  delegate :full_name, to: :user

  def form
    Form.new(self)
  end

  def mailing_address
    [mailing_street, mailing_city, mailing_zip].join(", ")
  end
end
