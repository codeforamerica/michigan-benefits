class AddPropertiesToCommonApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :common_applications, :properties, :string, array: true
      change_column_default :common_applications, :properties, from: nil, to: []
  end
end
