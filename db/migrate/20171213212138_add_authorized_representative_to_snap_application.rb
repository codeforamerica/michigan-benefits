class AddAuthorizedRepresentativeToSnapApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :authorized_representative, :boolean
    add_column :snap_applications, :authorized_representative_name, :string
  end
end
