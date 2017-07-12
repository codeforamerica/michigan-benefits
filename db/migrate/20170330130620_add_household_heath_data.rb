# frozen_string_literal: true

class AddHouseholdHeathData < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :any_medical_bill_help_last_3_months, :boolean, default: false, null: false
    add_column :apps, :any_lost_insurance_last_3_months, :boolean, default: false, null: false
  end
end
