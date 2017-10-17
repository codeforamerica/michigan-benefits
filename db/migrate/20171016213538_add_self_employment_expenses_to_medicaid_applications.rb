class AddSelfEmploymentExpensesToMedicaidApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :medicaid_applications, :self_employment_expenses, :integer
  end
end
