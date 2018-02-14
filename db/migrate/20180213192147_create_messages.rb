class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.timestamps
      t.string :phone
      t.text :body
    end
  end
end
