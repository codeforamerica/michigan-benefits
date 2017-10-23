class MoveInsuranceInfoToMember < ActiveRecord::Migration[5.1]
  def up
    add_column :members, :is_insured, :boolean
    add_column :members, :insurance_type, :string
    add_column :medicaid_applications, :anyone_is_insured, :boolean

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications SET anyone_is_insured=insured;

        UPDATE members
        SET
          is_insured=medicaid_applications.insured,
          insurance_type=medicaid_applications.insurance_type
        FROM (
          SELECT
            min(id) as id, benefit_application_id
          FROM
            members
          WHERE
            benefit_application_type = 'MedicaidApplication'
          GROUP BY benefit_application_id
        )
        AS primary_medicaid_members
        JOIN medicaid_applications
        ON benefit_application_id = medicaid_applications.id
        WHERE members.id = primary_medicaid_members.id;
      SQL

      remove_column :medicaid_applications, :insured
      remove_column :medicaid_applications, :insurance_type
    end
  end

  def down
    add_column :medicaid_applications, :insured, :boolean
    add_column :medicaid_applications, :insurance_type, :string

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications SET insured=anyone_is_insured;

        UPDATE medicaid_applications
        SET
          insured=primary_medicaid_members.is_insured,
          insurance_type=primary_medicaid_members.insurance_type
        FROM (
          SELECT
            min(id) as id, benefit_application_id, is_insured, insurance_type
          FROM
            members
          WHERE
            benefit_application_type = 'MedicaidApplication'
          GROUP BY benefit_application_id, is_insured, insurance_type
        )
        AS primary_medicaid_members
        WHERE medicaid_applications.id = primary_medicaid_members.benefit_application_id;
      SQL

      remove_column :members, :is_insured
      remove_column :members, :insurance_type
      remove_column :medicaid_applications, :anyone_is_insured
    end
  end
end
