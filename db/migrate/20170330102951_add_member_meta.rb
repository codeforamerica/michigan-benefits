# frozen_string_literal: true

class AddMemberMeta < ActiveRecord::Migration[5.0]
  def change
    add_column :household_members, :in_college, :boolean, default: false, null: false
    add_column :household_members, :is_disabled, :boolean, default: false, null: false
  end
end
