class AddDefaultToMembersBuyFoodWith < ActiveRecord::Migration[5.1]
  def change
    change_column_default :members, :buy_food_with, true
  end
end
