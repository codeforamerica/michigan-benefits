class AddEmailToSnapApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :email, :string
  end
end
