class RenameCollegeStudentToAnyoneInCollege < ActiveRecord::Migration[5.1]
  def up
    add_column :medicaid_applications, :anyone_in_college, :boolean

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications
        SET anyone_in_college = college_student;
      SQL

      remove_column :medicaid_applications, :college_student
    end
  end

  def down
    add_column :medicaid_applications, :college_student, :boolean

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications
        SET college_student = anyone_in_college;
      SQL

      remove_column :medicaid_applications, :anyone_in_college
    end
  end
end
