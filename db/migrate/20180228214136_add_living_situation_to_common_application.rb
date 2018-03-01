class AddLivingSituationToCommonApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :common_applications, :living_situation, :integer
    change_column_default :common_applications, :living_situation, from: nil, to: 0
  end
end
