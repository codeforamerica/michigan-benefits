class AddAllShareFoodCostsToNavigator < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :all_share_food_costs, :boolean
    change_column_default :application_navigators, :all_share_food_costs, from: nil, to: true
  end
end
