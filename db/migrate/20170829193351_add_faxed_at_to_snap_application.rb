class AddFaxedAtToSnapApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :faxed_at, :datetime
  end
end
