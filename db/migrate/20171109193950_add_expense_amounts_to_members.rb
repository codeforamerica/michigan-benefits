class AddExpenseAmountsToMembers < ActiveRecord::Migration[5.1]
  def up
    add_column :members, :student_loan_interest_expenses, :integer
    add_column :members, :child_support_alimony_arrears_expenses, :integer

    safety_assured do
      execute <<~SQL
        UPDATE members
        SET
          student_loan_interest_expenses=medicaid_applications.college_loan_interest_expenses,
          child_support_alimony_arrears_expenses=medicaid_applications.child_support_alimony_arrears_expenses,
          self_employed_monthly_expenses=medicaid_applications.self_employment_expenses
        FROM (
          SELECT min(id) as id, benefit_application_id
          FROM members
          WHERE benefit_application_type = 'MedicaidApplication'
          GROUP BY benefit_application_id
        ) AS primary_medicaid_members
        JOIN medicaid_applications
        ON benefit_application_id = medicaid_applications.id
        WHERE members.id = primary_medicaid_members.id
      SQL

      remove_column :medicaid_applications, :college_loan_interest_expenses
      remove_column :medicaid_applications, :child_support_alimony_arrears_expenses
      remove_column :medicaid_applications, :self_employment_expenses
    end
  end

  def down
    add_column :medicaid_applications, :college_loan_interest_expenses, :integer
    add_column :medicaid_applications, :child_support_alimony_arrears_expenses, :integer
    add_column :medicaid_applications, :self_employment_expenses, :integer

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications
        SET college_loan_interest_expenses=primary_medicaid_members.student_loan_interest_expenses,
           child_support_alimony_arrears_expenses=primary_medicaid_members.child_support_alimony_arrears_expenses,
           self_employment_expenses=primary_medicaid_members.self_employed_monthly_expenses
        FROM (
          SELECT min(id) as id, benefit_application_id, unemployment_income
          FROM members
          WHERE benefit_application_type = 'MedicaidApplication'
          GROUP BY benefit_application_id, unemployment_income
        )
        AS primary_medicaid_members
        WHERE medicaid_applications.id = primary_medicaid_members.benefit_application_id
      SQL

      remove_column :members, :student_loan_interest_expenses
      remove_column :members, :child_support_alimony_arrears_expenses
    end
  end
end
