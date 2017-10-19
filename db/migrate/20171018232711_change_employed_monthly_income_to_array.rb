class ChangeEmployedMonthlyIncomeToArray < ActiveRecord::Migration[5.1]
  def up
    add_column :medicaid_applications, :new_employed_monthly_income, :string, array: true
    change_column_default :medicaid_applications, :new_employed_monthly_income, []

    commit_db_transaction

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications
        SET new_employed_monthly_income = ARRAY[employed_monthly_income]
        WHERE employed_monthly_income IS NOT NULL;
      SQL
    end
  end

  def down
    remove_column :medicaid_applications, :new_employed_monthly_income
  end
end
