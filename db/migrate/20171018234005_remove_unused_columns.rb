class RemoveUnusedColumns < ActiveRecord::Migration[5.1]
  def change
    safety_assured do
      remove_column :medicaid_applications, :employed_monthly_income, :integer
      remove_column :medicaid_applications, :number_of_jobs, :integer

      rename_column :medicaid_applications, :new_employed_monthly_income, :employed_monthly_income
      rename_column :medicaid_applications, :new_number_of_jobs, :number_of_jobs
    end
  end
end
