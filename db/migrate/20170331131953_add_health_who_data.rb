# frozen_string_literal: true

class AddHealthWhoData < ActiveRecord::Migration[5.0]
  def change
    add_column :household_members, :medical_help, :boolean
    add_column :household_members, :insurance_lost_last_3_months, :boolean
  end
end
