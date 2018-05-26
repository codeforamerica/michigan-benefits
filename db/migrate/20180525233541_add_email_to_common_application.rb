class AddEmailToCommonApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :common_applications, :email, :string
  end
end
