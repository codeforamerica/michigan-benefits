# frozen_string_literal: true

class AddFieldsToHouseholdMember < ActiveRecord::Migration[5.0]
  def change
    add_column :household_members, :is_citizen, :boolean
    add_column :household_members, :is_new_mom, :boolean
    add_column :household_members, :needs_medical_bill_help, :boolean
    add_column :household_members, :is_living_elsewhere, :boolean
  end
end
