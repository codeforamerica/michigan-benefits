class AddScreenshotsToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :screenshots, :string, array: true
    change_column_default :messages, :screenshots, from: nil, to: []
  end
end
