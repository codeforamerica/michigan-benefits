class AddSignature < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :agree_to_terms, :boolean
    change_column_default :application_navigators, :agree_to_terms, from: nil, to: false

    add_column :common_applications, :signature, :string
    add_column :common_applications, :signed_at, :datetime
  end
end
