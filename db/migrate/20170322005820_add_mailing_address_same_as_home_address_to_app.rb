class AddMailingAddressSameAsHomeAddressToApp < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :mailing_address_same_as_home_address, :boolean
  end
end
