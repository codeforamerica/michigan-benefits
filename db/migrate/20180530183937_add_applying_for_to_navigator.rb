class AddApplyingForToNavigator < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :applying_for_food, :boolean
    change_column_default :application_navigators, :applying_for_food, from: nil, to: false

    add_column :application_navigators, :applying_for_healthcare, :boolean
    change_column_default :application_navigators, :applying_for_healthcare, from: nil, to: false
  end
end
