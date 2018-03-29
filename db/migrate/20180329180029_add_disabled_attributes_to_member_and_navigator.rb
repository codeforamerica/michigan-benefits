class AddDisabledAttributesToMemberAndNavigator < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :anyone_disabled, :boolean
    change_column_default :application_navigators, :anyone_disabled, from: nil, to: true

    add_column :household_members, :disabled, :integer
    change_column_default :household_members, :disabled, from: nil, to: 0
  end
end
