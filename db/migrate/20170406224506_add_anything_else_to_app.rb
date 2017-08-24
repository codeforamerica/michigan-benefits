# frozen_string_literal: true

class AddAnythingElseToApp < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :additional_information, :text
  end
end
