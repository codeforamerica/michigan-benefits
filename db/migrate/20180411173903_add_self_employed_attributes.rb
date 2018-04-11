class AddSelfEmployedAttributes < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :anyone_self_employed, :boolean
    change_column_default :application_navigators, :anyone_self_employed, from: nil, to: false

    add_column :household_members, :self_employed, :integer
    change_column_default :household_members, :self_employed, from: nil, to: 0
  end
end
