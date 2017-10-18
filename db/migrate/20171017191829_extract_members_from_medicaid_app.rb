class ExtractMembersFromMedicaidApp < ActiveRecord::Migration[5.1]
  def up
    add_column :members, :benefit_application_id, :bigint
    add_column :members, :benefit_application_type, :string

    safety_assured do
      execute <<~SQL
        UPDATE members SET benefit_application_id=snap_application_id;
        UPDATE members SET benefit_application_type='SnapApplication';
      SQL
    end

    change_column_null :members, :benefit_application_id, false
    change_column_null :members, :benefit_application_type, false
    safety_assured do
      remove_column :members, :snap_application_id

      execute <<~SQL
        INSERT INTO members
        (first_name,last_name,sex,benefit_application_id,benefit_application_type,created_at,updated_at)
        SELECT first_name, last_name, gender, id, 'MedicaidApplication', now(), now()
        FROM medicaid_applications;
      SQL

      remove_column :medicaid_applications, :first_name
      remove_column :medicaid_applications, :last_name
      remove_column :medicaid_applications, :gender
    end
  end

  def down
    add_column :medicaid_applications, :first_name, :string
    add_column :medicaid_applications, :last_name, :string
    add_column :medicaid_applications, :gender, :string

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications
        SET first_name=members.first_name, last_name=members.last_name, gender=members.sex
        FROM members
        WHERE members.benefit_application_type='MedicaidApplication'
        AND members.benefit_application_id=medicaid_applications.id;

        DELETE FROM members
        WHERE benefit_application_type='MedicaidApplication';
      SQL
    end

    add_column :members, :snap_application_id, :bigint

    safety_assured do
      execute <<~SQL
        UPDATE members SET snap_application_id=benefit_application_id;
      SQL

      remove_column :members, :benefit_application_id
      remove_column :members, :benefit_application_type
    end
  end
end
