class ExtractAddressesFromMedicaidApplications < ActiveRecord::Migration[5.1]
  def up
    add_column :addresses, :benefit_application_id, :bigint
    add_column :addresses, :benefit_application_type, :string

    safety_assured do
      execute <<~SQL
        UPDATE addresses SET benefit_application_id=snap_application_id;
        UPDATE addresses SET benefit_application_type='SnapApplication';
      SQL
    end

    change_column_null :addresses, :benefit_application_id, false
    change_column_null :addresses, :benefit_application_type, false

    safety_assured do
      remove_column :addresses, :snap_application_id

      execute <<~SQL
        INSERT INTO addresses
        (street_address,city,county,state,zip,created_at,updated_at, benefit_application_id, benefit_application_type, mailing)
        SELECT residential_street_address, residential_city, 'Genesee', 'MI', residential_zip, now(), now(), id, 'MedicaidApplication', false
        FROM medicaid_applications
        WHERE residential_street_address IS NOT null AND residential_city IS NOT null AND residential_zip IS NOT null;

        INSERT INTO addresses
        (street_address,city,county,state,zip,created_at,updated_at, benefit_application_id, benefit_application_type, mailing)
        SELECT mailing_street_address, mailing_city, 'Genesee', 'MI', mailing_zip, now(), now(), id, 'MedicaidApplication', true
        FROM medicaid_applications
        WHERE mailing_street_address IS NOT null AND mailing_city IS NOT null AND mailing_zip IS NOT null;
      SQL

      remove_column :medicaid_applications, :residential_street_address
      remove_column :medicaid_applications, :residential_city
      remove_column :medicaid_applications, :residential_zip
      remove_column :medicaid_applications, :mailing_street_address
      remove_column :medicaid_applications, :mailing_city
      remove_column :medicaid_applications, :mailing_zip
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
