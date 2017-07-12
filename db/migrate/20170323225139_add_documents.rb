# frozen_string_literal: true

class AddDocuments < ActiveRecord::Migration[5.0]
  def up
    create_table :documents do |t|
      t.references :app, foreign_key: true
      t.timestamps
    end

    add_attachment :documents, :file
  end

  def down
    drop_table :documents
  end
end
