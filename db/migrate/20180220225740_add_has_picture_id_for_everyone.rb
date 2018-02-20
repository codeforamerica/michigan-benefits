class AddHasPictureIdForEveryone < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :has_picture_id_for_everyone, :integer
    change_column_default :snap_applications, :has_picture_id_for_everyone, from: nil, to: 0

    add_column :medicaid_applications, :has_picture_id_for_everyone, :integer
    change_column_default :medicaid_applications, :has_picture_id_for_everyone, from: nil, to: 0
  end
end
