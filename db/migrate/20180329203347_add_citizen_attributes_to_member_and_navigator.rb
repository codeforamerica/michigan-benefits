class AddCitizenAttributesToMemberAndNavigator < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :everyone_citizen, :boolean
    change_column_default :application_navigators, :everyone_citizen, from: nil, to: true

    add_column :application_navigators, :immigration_info, :boolean
    change_column_default :application_navigators, :immigration_info, from: nil, to: false

    add_column :household_members, :citizen, :integer
    change_column_default :household_members, :citizen, from: nil, to: 0
  end
end
