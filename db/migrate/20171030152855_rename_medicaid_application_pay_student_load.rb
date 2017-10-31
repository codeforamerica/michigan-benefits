class RenameMedicaidApplicationPayStudentLoad < ActiveRecord::Migration[5.1]
  def up
    add_column(:members, :pay_student_loan_interest, :boolean)
    add_column(
      :medicaid_applications,
      :anyone_pay_student_loan_interest,
      :boolean,
    )

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications
        SET anyone_pay_student_loan_interest=pay_student_loan_interest
      SQL

      remove_column(
        :medicaid_applications,
        :pay_student_loan_interest,
      )
    end
  end

  def down
    add_column(
      :medicaid_applications,
      :pay_student_loan_interest,
      :boolean,
    )

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications
        SET pay_student_loan_interest=anyone_pay_student_loan_interest
      SQL

      remove_column(:members, :pay_student_loan_interest)
      remove_column(
        :medicaid_applications,
        :anyone_pay_student_loan_interest,
      )
    end
  end
end
