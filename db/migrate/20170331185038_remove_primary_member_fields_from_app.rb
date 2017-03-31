class RemovePrimaryMemberFieldsFromApp < ActiveRecord::Migration[5.0]
  def change
    remove_column :apps, :sex, :string
    remove_column :apps, :first_name, :string
    remove_column :apps, :last_name, :string
  end
end
