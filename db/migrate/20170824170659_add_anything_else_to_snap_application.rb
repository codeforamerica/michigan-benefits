class AddAnythingElseToSnapApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :additional_information, :text
  end
end
