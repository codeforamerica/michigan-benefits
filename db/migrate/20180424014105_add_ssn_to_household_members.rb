class AddSsnToHouseholdMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :household_members, :encrypted_ssn, :string
    add_column :household_members, :encrypted_ssn_iv, :string
  end
end
