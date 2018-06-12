class RemoveMemberIdFromEmployments < ActiveRecord::Migration[5.1]
  def change
    safety_assured do
      remove_column :employments, :member_id, :integer
    end
  end
end
