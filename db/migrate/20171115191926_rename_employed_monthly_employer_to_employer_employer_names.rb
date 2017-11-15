class RenameEmployedMonthlyEmployerToEmployerEmployerNames < ActiveRecord::Migration[5.1]
  def up
    add_column :members, :employed_employer_names, :string, array: true
    add_column :members, :employed_pay_quantities, :string, array: true
    change_column_default :members, :employed_employer_names, []
    change_column_default :members, :employed_pay_quantities, []

    safety_assured do
      execute <<~SQL
        UPDATE members
        SET employed_employer_names=employed_monthly_employer;

        UPDATE members
        SET employed_pay_quantities=employed_monthly_income;
      SQL

      remove_column(:members, :employed_monthly_employer)
      remove_column(:members, :employed_monthly_income)
    end
  end

  def down
    add_column :members, :employed_monthly_employer, :string, array: true
    add_column :members, :employed_monthly_income, :string, array: true
    change_column_default :members, :employed_monthly_employer, []
    change_column_default :members, :employed_monthly_income, []

    safety_assured do
      execute <<~SQL
        UPDATE members
        SET employed_monthly_employer=employed_employer_names;

        UPDATE members
        SET employed_monthly_income=employed_pay_quantities;
      SQL

      remove_column(:members, :employed_employer_names)
      remove_column(:members, :employed_pay_quantities)
    end
  end
end
