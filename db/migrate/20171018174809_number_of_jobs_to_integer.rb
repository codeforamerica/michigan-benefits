class NumberOfJobsToInteger < ActiveRecord::Migration[5.1]
  def up
    add_column :medicaid_applications, :new_number_of_jobs, :integer

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications
        SET new_number_of_jobs=1
        WHERE number_of_jobs='1 job';
        UPDATE medicaid_applications
        SET new_number_of_jobs=2
        WHERE number_of_jobs='2 jobs';
        UPDATE medicaid_applications
        SET new_number_of_jobs=3
        WHERE number_of_jobs='3 or more jobs';
      SQL
    end
  end

  def down
    remove_column :medicaid_applications, :new_number_of_jobs
  end
end
