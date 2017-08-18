class AddIncomeFieldsToSnapApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :money_or_accounts_income, :boolean
    add_column :snap_applications, :real_estate_income, :boolean
    add_column :snap_applications, :vehicle_income, :boolean
    add_column :snap_applications, :financial_accounts, :string, default: [], array: true
    add_column :snap_applications, :total_money, :integer
  end
end
