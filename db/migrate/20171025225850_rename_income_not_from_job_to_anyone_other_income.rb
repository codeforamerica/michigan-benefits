class RenameIncomeNotFromJobToAnyoneOtherIncome < ActiveRecord::Migration[5.1]
  def up
    add_column :medicaid_applications, :anyone_other_income, :boolean
    change_column_default :medicaid_applications, :anyone_other_income, false

    safety_assured do
      execute "UPDATE medicaid_applications SET anyone_other_income=income_not_from_job"
      remove_column :medicaid_applications, :income_not_from_job, :boolean
    end
  end

  def down
    add_column :medicaid_applications, :income_not_from_job, :boolean

    safety_assured do
      execute "UPDATE medicaid_applications SET income_not_from_job=anyone_other_income"
      remove_column :medicaid_applications, :anyone_other_income
    end
  end
end
