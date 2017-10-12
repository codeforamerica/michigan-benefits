class AddIncomeFields < ActiveRecord::Migration[5.1]
  def change
    add_column :medicaid_applications, :employed_monthly_income, :integer
    add_column :medicaid_applications, :self_employed_monthly_income, :integer
    add_column :medicaid_applications, :unemployment_income, :integer

    add_column :medicaid_applications, :college_loan_interest_expenses, :integer
    add_column :medicaid_applications, :child_support_alimony_arrears_expenses, :integer
  end
end
