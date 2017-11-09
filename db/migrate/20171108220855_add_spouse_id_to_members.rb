class AddSpouseIdToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :spouse_id, :integer, index: true
  end
end
