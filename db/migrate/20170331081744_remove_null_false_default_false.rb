# frozen_string_literal: true

class RemoveNullFalseDefaultFalse < ActiveRecord::Migration[5.0]
  def change
    change_column :apps, :unstable_housing,                     :boolean, null: true
    change_column :apps, :any_medical_bill_help_last_3_months,  :boolean, null: true
    change_column :apps, :any_lost_insurance_last_3_months,     :boolean, null: true
    change_column :apps, :has_accounts,                         :boolean, null: true
    change_column :apps, :has_home,                             :boolean, null: true
    change_column :apps, :has_vehicle,                          :boolean, null: true

    change_column :household_members, :in_college,    :boolean, null: true
    change_column :household_members, :is_disabled,   :boolean, null: true
  end
end
