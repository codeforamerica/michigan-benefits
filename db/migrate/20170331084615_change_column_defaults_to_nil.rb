# frozen_string_literal: true

class ChangeColumnDefaultsToNil < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:apps, :unstable_housing, nil)
    change_column_default(:apps, :any_medical_bill_help_last_3_months, nil)
    change_column_default(:apps, :any_lost_insurance_last_3_months, nil)
    change_column_default(:apps, :has_accounts, nil)
    change_column_default(:apps, :has_home, nil)
    change_column_default(:apps, :has_vehicle, nil)
    change_column_default(:household_members, :in_college, nil)
    change_column_default(:household_members, :is_disabled, nil)
  end
end
