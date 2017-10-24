class AddNumberOfJobsToMembers < ActiveRecord::Migration[5.1]
  def up
    add_column :members, :employed_number_of_jobs, :integer
    add_column :members, :employed_monthly_income, :string, array: true
    change_column_default :members, :employed_monthly_income, []

    safety_assured do
      execute <<~SQL
        UPDATE members
        SET employed_number_of_jobs=medicaid_applications.number_of_jobs, employment_status='employed', employed_monthly_income=medicaid_applications.employed_monthly_income
        FROM medicaid_applications
        WHERE members.benefit_application_type='MedicaidApplication'
        AND members.benefit_application_id=medicaid_applications.id
        AND medicaid_applications.employed = true;
      SQL
    end
  end

  def down
    remove_column :members, :employed_number_of_jobs, :integer
    remove_column :members, :employed_monthly_income, :string, array: true
  end
end
