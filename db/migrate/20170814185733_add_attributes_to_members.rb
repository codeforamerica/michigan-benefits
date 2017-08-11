class AddAttributesToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :birthday, :datetime
    add_column :members, :buy_food_with, :boolean
    add_column :members, :relationship, :string
    add_column :members, :requesting_food_assistance, :boolean, default: true
  end
end
