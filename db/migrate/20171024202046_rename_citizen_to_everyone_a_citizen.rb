class RenameCitizenToEveryoneACitizen < ActiveRecord::Migration[5.1]
  def up
    add_column :medicaid_applications, :everyone_a_citizen, :boolean

    safety_assured do
      execute "UPDATE medicaid_applications SET everyone_a_citizen=citizen"
      remove_column :medicaid_applications, :citizen
    end
  end

  def down
    add_column :medicaid_applications, :citizen, :boolean

    safety_assured do
      execute "UPDATE medicaid_applications SET citizen=everyone_a_citizen"
      remove_column :medicaid_applications, :everyone_a_citizen
    end
  end
end
