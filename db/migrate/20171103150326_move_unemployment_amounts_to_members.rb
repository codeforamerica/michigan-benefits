class MoveUnemploymentAmountsToMembers < ActiveRecord::Migration[5.1]
  def up
    add_column :members, :unemployment_income, :integer

    safety_assured do
      execute <<~SQL
        UPDATE members
        SET
          unemployment_income=medicaid_applications.unemployment_income
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

      remove_column :medicaid_applications, :unemployment_income
    end
  end

  def down
    add_column :medicaid_applications, :unemployment_income, :integer

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications
        SET unemployment_income=primary_medicaid_members.unemployment_income
        FROM (
          SELECT min(id) as id, benefit_application_id, unemployment_income
          FROM members
          WHERE benefit_application_type = 'MedicaidApplication'
          GROUP BY benefit_application_id, unemployment_income
        )
        AS primary_medicaid_members
        WHERE medicaid_applications.id = primary_medicaid_members.benefit_application_id
      SQL

      remove_column :members, :unemployment_income
    end
  end
end
