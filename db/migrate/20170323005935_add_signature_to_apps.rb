class AddSignatureToApps < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :signature, :string
  end
end
