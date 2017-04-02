class AddProfessionToHouseholdMember < ActiveRecord::Migration[5.0]
  def change
    add_column :household_members, :profession, :string
  end
end
