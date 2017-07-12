# frozen_string_literal: true

class AddAnythingElseToApp < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :anything_else, :text
  end
end
