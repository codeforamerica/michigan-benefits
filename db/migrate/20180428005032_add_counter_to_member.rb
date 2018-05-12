class AddCounterToMember < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :employments_count, :integer
    change_column_default :members, :employments_count, from: nil, to: 0
  end
end
