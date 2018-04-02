class AddFosterCareAttributesToMemberAndNavigator < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :anyone_foster_care_at_18, :boolean
    change_column_default :application_navigators, :anyone_foster_care_at_18, from: nil, to: false

    add_column :household_members, :foster_care_at_18, :integer
    change_column_default :household_members, :foster_care_at_18, from: nil, to: 0
  end
end
