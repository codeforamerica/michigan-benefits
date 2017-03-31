class AddFilerTypeToHouseholdMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :household_members, :filing_status, :string
  end
end
