class AddStreetAddress2ToAddress < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :street_address_2, :string
  end
end
