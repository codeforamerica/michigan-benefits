class AddAuthorizedRepresentativeAttributes < ActiveRecord::Migration[5.1]
  def change
    add_column :common_applications, :authorized_representative, :boolean
    change_column_default :common_applications, :authorized_representative, from: nil, to: false

    add_column :common_applications, :authorized_representative_name, :string
    add_column :common_applications, :authorized_representative_phone, :string
  end
end
