class AddYesNoFields < ActiveRecord::Migration[5.1]
  def change
    add_column :medicaid_applications, :mail_sent_to_residential, :boolean
    add_column :medicaid_applications, :homeless, :boolean
    add_column :medicaid_applications, :reliable_mail_address, :boolean
    add_column :medicaid_applications, :pay_child_support_alimony_arrears, :boolean
    add_column :medicaid_applications, :pay_student_loan_interest, :boolean
    add_column :medicaid_applications, :disabled, :boolean
    add_column :medicaid_applications, :new_mom, :boolean
    add_column :medicaid_applications, :need_medical_expense_help_3_months, :boolean
    add_column :medicaid_applications, :caretaker_or_parent, :boolean
    add_column :medicaid_applications, :citizen, :boolean
    add_column :medicaid_applications, :college_student, :boolean

    add_column :medicaid_applications, :insurance_type, :string
  end
end
