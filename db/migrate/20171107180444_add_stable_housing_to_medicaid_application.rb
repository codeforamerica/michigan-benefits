class AddStableHousingToMedicaidApplication < ActiveRecord::Migration[5.1]
  def up
    add_column :medicaid_applications, :stable_housing, :boolean

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications
        SET stable_housing=mail_sent_to_residential
      SQL

      remove_column(:medicaid_applications, :mail_sent_to_residential)
    end
  end

  def down
    add_column :medicaid_applications, :mail_sent_to_residential, :boolean

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications
        SET mail_sent_to_residential=stable_housing
      SQL

      remove_column(:medicaid_applications, :stable_housing)
    end
  end
end
