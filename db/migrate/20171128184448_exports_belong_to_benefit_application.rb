class ExportsBelongToBenefitApplication < ActiveRecord::Migration[5.1]
  def up
    add_column :exports, :benefit_application_id, :bigint
    add_column :exports, :benefit_application_type, :string

    safety_assured do
      execute <<~SQL
        UPDATE exports SET benefit_application_id=snap_application_id;
        UPDATE exports SET benefit_application_type='SnapApplication';
      SQL

      add_index(
        :exports,
        %i(benefit_application_type benefit_application_id),
        name: "index_exports_on_benefit_app_type_and_benefit_app_id",
      )
      remove_column :exports, :snap_application_id
    end

    change_column_null :exports, :benefit_application_id, false
    change_column_null :exports, :benefit_application_type, false
  end

  def down
    add_column :exports, :snap_application_id, :bigint

    safety_assured do
      execute <<~SQL
        UPDATE exports SET snap_application_id=benefit_application_id;
      SQL

      remove_column :exports, :benefit_application_id
      remove_column :exports, :benefit_application_type
    end
  end
end
