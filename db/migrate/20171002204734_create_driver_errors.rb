class CreateDriverErrors < ActiveRecord::Migration[5.1]
  def change
    create_table :driver_errors do |t|
      t.references :driver_application, null: false, foreign_key: true
      t.string :error_class, null: false
      t.string :error_message, null: false
      t.string :page_class, null: false
      t.text :page_html, null: false

      t.timestamps
    end
  end
end
