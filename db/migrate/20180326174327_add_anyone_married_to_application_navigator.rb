class AddAnyoneMarriedToApplicationNavigator < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :anyone_married, :boolean
    change_column_default :application_navigators, :anyone_married, from: nil, to: false
  end
end
