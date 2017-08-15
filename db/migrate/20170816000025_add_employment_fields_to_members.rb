class AddEmploymentFieldsToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :employed_employer_name, :string
    add_column :members, :employed_hours_per_week, :string
    add_column :members, :employed_pay_quantity, :string
    add_column :members, :employed_pay_interval, :string

    add_column :members, :self_employed_profession, :string
    add_column :members, :self_employed_monthly_income, :string
    add_column :members, :self_employed_monthly_expenses, :string
  end
end
