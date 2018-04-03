class AddPregnancyAttributesToMemberAndNavigator < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :anyone_pregnant, :boolean
    change_column_default :application_navigators, :anyone_pregnant, from: nil, to: false

    add_column :household_members, :pregnant, :integer
    change_column_default :household_members, :pregnant, from: nil, to: 0
  end
end
