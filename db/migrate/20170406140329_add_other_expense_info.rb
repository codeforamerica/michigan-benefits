# frozen_string_literal: true

class AddOtherExpenseInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :monthly_care_expenses, :integer
    add_column :apps, :care_expenses, :text, array: true, default: []
    add_column :apps, :monthly_medical_expenses, :integer
    add_column :apps, :medical_expenses, :text, array: true, default: []
    add_column :apps, :monthly_court_ordered_expenses, :integer
    add_column :apps, :court_ordered_expenses, :text, array: true, default: []
    add_column :apps, :monthly_tax_deductible_expenses, :integer
    add_column :apps, :tax_deductible_expenses, :text, array: true, default: []
  end
end
