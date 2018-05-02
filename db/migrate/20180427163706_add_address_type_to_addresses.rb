class AddAddressTypeToAddresses < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :address_type, :string
  end
end
