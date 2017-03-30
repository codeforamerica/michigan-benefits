class AddHouseholdMetaFields < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :everyone_a_citizen, :boolean
    add_column :apps, :anyone_disabled, :boolean
    add_column :apps, :any_new_moms, :boolean
    add_column :apps, :any_medical_bill_help, :boolean
    add_column :apps, :anyone_in_college, :boolean
    add_column :apps, :anyone_living_elsewhere, :boolean
  end
end
