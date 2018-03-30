class AddVeteranAttributesToMemberAndNavigator < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :anyone_veteran, :boolean
    change_column_default :application_navigators, :anyone_veteran, from: nil, to: true

    add_column :household_members, :veteran, :integer
    change_column_default :household_members, :veteran, from: nil, to: 0
  end
end
